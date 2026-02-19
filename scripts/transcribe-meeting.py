#!/usr/bin/env python3
"""
Meeting Transcription with Speaker Diarization

Architecture:
  1. Transcription: OpenAI Whisper API (handles Hindi/Hinglish, word timestamps)
  2. Diarization: MFCC-based speaker embeddings + spectral clustering
  3. Speaker ID: Match clusters to reference voice samples via cosine similarity

Designed for low-resource VPS (2 vCPU, 2GB RAM, no GPU).
"""

import argparse
import json
import os
import subprocess
import sys
import tempfile
import wave
from pathlib import Path

import numpy as np
from scipy.io import wavfile
from scipy.fftpack import dct
from sklearn.cluster import SpectralClustering, AgglomerativeClustering
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import StandardScaler


# ── Audio utilities ──────────────────────────────────────────────────────────

def convert_to_wav(input_path: str, output_path: str, sr: int = 16000) -> str:
    """Convert any audio format to 16kHz mono WAV using ffmpeg."""
    cmd = [
        "ffmpeg", "-y", "-i", input_path,
        "-ar", str(sr), "-ac", "1", "-f", "wav", output_path
    ]
    subprocess.run(cmd, capture_output=True, check=True)
    return output_path


def load_wav(path: str):
    """Load WAV file, return (sample_rate, samples as float32 [-1,1])."""
    sr, data = wavfile.read(path)
    if data.dtype == np.int16:
        data = data.astype(np.float32) / 32768.0
    elif data.dtype == np.int32:
        data = data.astype(np.float32) / 2147483648.0
    elif data.dtype != np.float32:
        data = data.astype(np.float32)
    if len(data.shape) > 1:
        data = data.mean(axis=1)
    return sr, data


# ── MFCC Feature Extraction (no librosa dependency) ─────────────────────────

def hz_to_mel(hz):
    return 2595 * np.log10(1 + hz / 700)

def mel_to_hz(mel):
    return 700 * (10 ** (mel / 2595) - 1)

def mel_filterbank(num_filters, fft_size, sr):
    low_mel = hz_to_mel(80)
    high_mel = hz_to_mel(sr / 2)
    mel_points = np.linspace(low_mel, high_mel, num_filters + 2)
    hz_points = mel_to_hz(mel_points)
    bins = np.floor((fft_size + 1) * hz_points / sr).astype(int)
    
    fbank = np.zeros((num_filters, fft_size // 2 + 1))
    for i in range(num_filters):
        for j in range(bins[i], bins[i + 1]):
            fbank[i, j] = (j - bins[i]) / max(bins[i + 1] - bins[i], 1)
        for j in range(bins[i + 1], bins[i + 2]):
            fbank[i, j] = (bins[i + 2] - j) / max(bins[i + 2] - bins[i + 1], 1)
    return fbank


def extract_mfcc(samples, sr, n_mfcc=20, frame_ms=25, hop_ms=10, n_filters=40):
    """Extract MFCCs from audio samples."""
    frame_len = int(sr * frame_ms / 1000)
    hop_len = int(sr * hop_ms / 1000)
    fft_size = 1
    while fft_size < frame_len:
        fft_size *= 2
    
    # Pad signal
    num_frames = max(1, 1 + (len(samples) - frame_len) // hop_len)
    pad_len = (num_frames - 1) * hop_len + frame_len
    if pad_len > len(samples):
        samples = np.append(samples, np.zeros(pad_len - len(samples)))
    
    # Frame and window
    indices = np.arange(frame_len)[None, :] + np.arange(num_frames)[:, None] * hop_len
    frames = samples[indices] * np.hamming(frame_len)
    
    # Power spectrum
    mag = np.abs(np.fft.rfft(frames, n=fft_size))
    power = mag ** 2 / fft_size
    
    # Mel filterbank
    fbank = mel_filterbank(n_filters, fft_size, sr)
    mel_spec = np.dot(power, fbank.T)
    mel_spec = np.where(mel_spec == 0, np.finfo(float).eps, mel_spec)
    log_mel = np.log(mel_spec)
    
    # DCT to get MFCCs
    mfccs = dct(log_mel, type=2, axis=1, norm='ortho')[:, :n_mfcc]
    return mfccs


def compute_speaker_embedding(samples, sr):
    """Compute a fixed-length speaker embedding from audio."""
    if len(samples) < sr * 0.5:  # less than 0.5s
        # Pad short segments
        samples = np.pad(samples, (0, int(sr * 0.5) - len(samples)))
    
    mfccs = extract_mfcc(samples, sr)
    # Use mean + std of MFCCs as embedding
    embedding = np.concatenate([mfccs.mean(axis=0), mfccs.std(axis=0)])
    return embedding


# ── Segmentation ─────────────────────────────────────────────────────────────

def segment_by_energy(samples, sr, min_segment_sec=2.0, max_segment_sec=30.0,
                      silence_threshold=0.01, min_silence_ms=500):
    """Split audio into segments based on energy/silence detection."""
    hop_ms = 20
    hop_samples = int(sr * hop_ms / 1000)
    frame_len = int(sr * 50 / 1000)  # 50ms frames for energy
    
    # Compute frame energy
    n_frames = max(1, (len(samples) - frame_len) // hop_samples)
    energies = []
    for i in range(n_frames):
        start = i * hop_samples
        frame = samples[start:start + frame_len]
        energies.append(np.sqrt(np.mean(frame ** 2)))
    energies = np.array(energies)
    
    # Find silence regions
    is_silence = energies < silence_threshold
    
    # Find segment boundaries at silence points
    segments = []
    seg_start = 0
    min_frames = int(min_segment_sec * 1000 / hop_ms)
    max_frames = int(max_segment_sec * 1000 / hop_ms)
    min_silence_frames = int(min_silence_ms / hop_ms)
    
    i = 0
    while i < n_frames:
        # Check if we've hit a silence region and segment is long enough
        if is_silence[i] and (i - seg_start) >= min_frames:
            # Find end of silence
            silence_start = i
            while i < n_frames and is_silence[i]:
                i += 1
            silence_len = i - silence_start
            
            if silence_len >= min_silence_frames:
                # Create segment
                mid_silence = silence_start + silence_len // 2
                seg_end_sample = mid_silence * hop_samples
                seg_start_sample = seg_start * hop_samples
                segments.append((seg_start_sample / sr, seg_end_sample / sr))
                seg_start = mid_silence
        
        # Force split if segment too long
        if (i - seg_start) >= max_frames:
            seg_end_sample = i * hop_samples
            seg_start_sample = seg_start * hop_samples
            segments.append((seg_start_sample / sr, seg_end_sample / sr))
            seg_start = i
        
        i += 1
    
    # Last segment
    if seg_start < n_frames:
        segments.append((seg_start * hop_samples / sr, len(samples) / sr))
    
    # Filter out very short segments
    segments = [(s, e) for s, e in segments if (e - s) >= 0.5]
    
    return segments


# ── Diarization (clustering) ────────────────────────────────────────────────

def diarize_segments(samples, sr, segments, n_speakers=None):
    """Assign speaker labels to segments using clustering."""
    if not segments:
        return []
    
    # Compute embeddings for each segment
    embeddings = []
    valid_segments = []
    for start, end in segments:
        s = int(start * sr)
        e = int(end * sr)
        seg_samples = samples[s:e]
        if len(seg_samples) < sr * 0.3:
            continue
        emb = compute_speaker_embedding(seg_samples, sr)
        embeddings.append(emb)
        valid_segments.append((start, end))
    
    if len(embeddings) < 2:
        return [(s, e, "SPEAKER_0") for s, e in valid_segments]
    
    embeddings = np.array(embeddings)
    scaler = StandardScaler()
    embeddings_scaled = scaler.fit_transform(embeddings)
    
    # Determine number of speakers
    if n_speakers is None:
        # Heuristic: use silhouette score to pick k
        from sklearn.metrics import silhouette_score
        best_k = 2
        best_score = -1
        max_k = min(6, len(embeddings) - 1)
        for k in range(2, max_k + 1):
            try:
                clustering = AgglomerativeClustering(n_clusters=k)
                labels = clustering.fit_predict(embeddings_scaled)
                score = silhouette_score(embeddings_scaled, labels)
                if score > best_score:
                    best_score = score
                    best_k = k
            except Exception:
                continue
        n_speakers = best_k
    
    clustering = AgglomerativeClustering(n_clusters=n_speakers)
    labels = clustering.fit_predict(embeddings_scaled)
    
    result = []
    for (start, end), label in zip(valid_segments, labels):
        result.append((start, end, f"SPEAKER_{label}"))
    
    return result


# ── Reference voice matching ────────────────────────────────────────────────

def load_reference_voices(ref_dir: str, sr: int = 16000):
    """Load reference voice samples and compute embeddings."""
    ref_dir = Path(ref_dir)
    if not ref_dir.exists():
        return {}
    
    references = {}
    for f in ref_dir.iterdir():
        if f.suffix.lower() in ('.wav', '.ogg', '.oga', '.mp3', '.m4a', '.flac', '.opus'):
            name = f.stem.lower()
            with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as tmp:
                tmp_path = tmp.name
            try:
                convert_to_wav(str(f), tmp_path, sr)
                _, samples = load_wav(tmp_path)
                emb = compute_speaker_embedding(samples, sr)
                references[name] = emb
                print(f"  Loaded reference: {name} ({f.name})", file=sys.stderr)
            except Exception as e:
                print(f"  Warning: Could not load {f.name}: {e}", file=sys.stderr)
            finally:
                if os.path.exists(tmp_path):
                    os.unlink(tmp_path)
    
    return references


def match_speakers_to_references(samples, sr, diarized_segments, references):
    """Match SPEAKER_N labels to reference voice names."""
    if not references or not diarized_segments:
        return diarized_segments
    
    # Compute mean embedding per speaker cluster
    speaker_embeddings = {}
    for start, end, label in diarized_segments:
        s = int(start * sr)
        e = int(end * sr)
        seg = samples[s:e]
        if len(seg) < sr * 0.3:
            continue
        emb = compute_speaker_embedding(seg, sr)
        if label not in speaker_embeddings:
            speaker_embeddings[label] = []
        speaker_embeddings[label].append(emb)
    
    # Average embeddings per speaker
    speaker_mean = {}
    for label, embs in speaker_embeddings.items():
        speaker_mean[label] = np.mean(embs, axis=0).reshape(1, -1)
    
    # Match to references
    ref_names = list(references.keys())
    ref_embs = np.array([references[n] for n in ref_names])
    
    label_map = {}
    used_refs = set()
    
    # Compute all similarities
    similarities = {}
    for label, mean_emb in speaker_mean.items():
        sims = cosine_similarity(mean_emb, ref_embs)[0]
        for i, ref_name in enumerate(ref_names):
            similarities[(label, ref_name)] = sims[i]
    
    # Greedy matching: best similarity first
    sorted_pairs = sorted(similarities.items(), key=lambda x: -x[1])
    for (label, ref_name), sim in sorted_pairs:
        if label in label_map or ref_name in used_refs:
            continue
        if sim > 0.5:  # threshold
            label_map[label] = ref_name.upper()
            used_refs.add(ref_name)
            print(f"  Matched {label} → {ref_name.upper()} (similarity: {sim:.3f})", file=sys.stderr)
    
    # Apply mapping
    result = []
    for start, end, label in diarized_segments:
        new_label = label_map.get(label, label)
        result.append((start, end, new_label))
    
    return result


# ── Transcription via OpenAI Whisper API ─────────────────────────────────────

def transcribe_with_whisper_api(audio_path: str, language: str = "hi"):
    """Transcribe audio using OpenAI Whisper API with word timestamps."""
    from openai import OpenAI
    
    client = OpenAI()
    
    # Check file size — API limit is 25MB
    file_size = os.path.getsize(audio_path)
    if file_size > 25 * 1024 * 1024:
        print(f"Warning: File is {file_size/1024/1024:.1f}MB. Splitting into chunks...", file=sys.stderr)
        return transcribe_chunked(audio_path, language)
    
    with open(audio_path, "rb") as f:
        response = client.audio.transcriptions.create(
            model="whisper-1",
            file=f,
            language=language,
            response_format="verbose_json",
            timestamp_granularities=["segment"]
        )
    
    return response


def transcribe_chunked(audio_path: str, language: str = "hi", chunk_minutes: int = 20):
    """Split large files and transcribe in chunks."""
    from pydub import AudioSegment
    
    audio = AudioSegment.from_file(audio_path)
    chunk_ms = chunk_minutes * 60 * 1000
    
    all_segments = []
    offset = 0.0
    
    for i in range(0, len(audio), chunk_ms):
        chunk = audio[i:i + chunk_ms]
        with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as tmp:
            chunk.export(tmp.name, format="mp3", bitrate="64k")
            tmp_path = tmp.name
        
        try:
            from openai import OpenAI
            client = OpenAI()
            with open(tmp_path, "rb") as f:
                response = client.audio.transcriptions.create(
                    model="whisper-1",
                    file=f,
                    language=language,
                    response_format="verbose_json",
                    timestamp_granularities=["segment"]
                )
            
            for seg in response.segments:
                seg_dict = {
                    "start": seg.start + offset,
                    "end": seg.end + offset,
                    "text": seg.text
                }
                all_segments.append(seg_dict)
        finally:
            os.unlink(tmp_path)
        
        offset = i / 1000.0 + len(chunk) / 1000.0
    
    return all_segments


# ── Main pipeline ────────────────────────────────────────────────────────────

def format_timestamp(seconds: float) -> str:
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = int(seconds % 60)
    if h > 0:
        return f"{h:02d}:{m:02d}:{s:02d}"
    return f"{m:02d}:{s:02d}"


def run_pipeline(audio_path: str, ref_dir: str = None, n_speakers: int = None,
                 language: str = "hi", output_path: str = None):
    """Run the full transcription + diarization pipeline."""
    
    print(f"🎤 Processing: {audio_path}", file=sys.stderr)
    
    # Step 1: Convert to WAV for diarization
    print("📝 Step 1: Converting audio to WAV...", file=sys.stderr)
    with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as tmp:
        wav_path = tmp.name
    
    try:
        convert_to_wav(audio_path, wav_path)
        sr, samples = load_wav(wav_path)
        duration = len(samples) / sr
        print(f"   Duration: {format_timestamp(duration)} ({duration:.1f}s)", file=sys.stderr)
        
        # Step 2: Segment audio
        print("🔪 Step 2: Segmenting audio by silence...", file=sys.stderr)
        segments = segment_by_energy(samples, sr)
        print(f"   Found {len(segments)} segments", file=sys.stderr)
        
        # Step 3: Diarize (cluster segments by speaker)
        print("👥 Step 3: Diarizing (clustering speakers)...", file=sys.stderr)
        diarized = diarize_segments(samples, sr, segments, n_speakers)
        n_detected = len(set(label for _, _, label in diarized))
        print(f"   Detected {n_detected} speakers", file=sys.stderr)
        
        # Step 4: Match to reference voices
        if ref_dir:
            print(f"🔍 Step 4: Matching against reference voices in {ref_dir}...", file=sys.stderr)
            references = load_reference_voices(ref_dir, sr)
            if references:
                diarized = match_speakers_to_references(samples, sr, diarized, references)
            else:
                print("   No reference voices found", file=sys.stderr)
        
        # Step 5: Transcribe via Whisper API
        print("🗣️  Step 5: Transcribing via OpenAI Whisper API...", file=sys.stderr)
        whisper_result = transcribe_with_whisper_api(audio_path, language)
        
        # Step 6: Merge diarization with transcription
        print("🔗 Step 6: Merging speaker labels with transcript...", file=sys.stderr)
        
        # Get Whisper segments
        if hasattr(whisper_result, 'segments'):
            whisper_segments = [
                {"start": s.start, "end": s.end, "text": s.text}
                for s in whisper_result.segments
            ]
        elif isinstance(whisper_result, list):
            whisper_segments = whisper_result
        else:
            whisper_segments = [{"start": 0, "end": duration, "text": whisper_result.text}]
        
        # For each whisper segment, find the best matching diarization speaker
        transcript_lines = []
        for wseg in whisper_segments:
            w_mid = (wseg["start"] + wseg["end"]) / 2
            
            # Find overlapping diarization segment
            best_label = "UNKNOWN"
            best_overlap = 0
            for d_start, d_end, d_label in diarized:
                overlap_start = max(wseg["start"], d_start)
                overlap_end = min(wseg["end"], d_end)
                overlap = max(0, overlap_end - overlap_start)
                if overlap > best_overlap:
                    best_overlap = overlap
                    best_label = d_label
            
            transcript_lines.append({
                "start": wseg["start"],
                "end": wseg["end"],
                "speaker": best_label,
                "text": wseg["text"].strip()
            })
        
        # Step 7: Format output
        print("📄 Step 7: Formatting output...\n", file=sys.stderr)
        
        txt_output = format_txt(transcript_lines)
        md_output = format_md(transcript_lines, audio_path)
        
        # Print to stdout
        print(txt_output)
        
        # Save to file(s)
        if output_path:
            base = output_path.rsplit('.', 1)[0] if '.' in output_path else output_path
            
            txt_path = base + '.txt'
            with open(txt_path, 'w') as f:
                f.write(txt_output)
            print(f"\n💾 Saved: {txt_path}", file=sys.stderr)
            
            md_path = base + '.md'
            with open(md_path, 'w') as f:
                f.write(md_output)
            print(f"💾 Saved: {md_path}", file=sys.stderr)
        
        print(f"\n✅ Done!", file=sys.stderr)
        
    finally:
        if os.path.exists(wav_path):
            os.unlink(wav_path)


def format_txt(lines):
    """Format transcript as plain text."""
    output = []
    prev_speaker = None
    for line in lines:
        ts = format_timestamp(line["start"])
        speaker = line["speaker"]
        text = line["text"]
        
        if speaker != prev_speaker:
            if output:
                output.append("")
            output.append(f"[{ts}] [{speaker}]")
            prev_speaker = speaker
        
        output.append(f"  {text}")
    
    return "\n".join(output)


def format_md(lines, audio_path):
    """Format transcript as Markdown."""
    output = [
        f"# Meeting Transcript",
        f"",
        f"**Source:** `{os.path.basename(audio_path)}`",
        f"**Generated:** {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M')}",
        f"",
        f"---",
        f""
    ]
    
    prev_speaker = None
    for line in lines:
        ts = format_timestamp(line["start"])
        speaker = line["speaker"]
        text = line["text"]
        
        if speaker != prev_speaker:
            output.append(f"")
            output.append(f"### `{ts}` — **{speaker}**")
            output.append(f"")
            prev_speaker = speaker
        
        output.append(f"{text}")
    
    return "\n".join(output)


# ── CLI ──────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Transcribe meeting audio with speaker diarization",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --audio meeting.mp3
  %(prog)s --audio meeting.mp3 --references voice-references/ --output transcript
  %(prog)s --audio meeting.mp3 --speakers 3 --language hi --output meeting-notes

Reference voices:
  Place labeled audio files in the references directory:
    voice-references/hmt.ogg
    voice-references/parveen.ogg
    voice-references/vinay.ogg
  
  The filename (without extension) becomes the speaker label.
  Supports: .wav, .ogg, .oga, .mp3, .m4a, .flac, .opus
        """
    )
    
    parser.add_argument("--audio", "-a", required=True, help="Path to meeting audio file")
    parser.add_argument("--references", "-r", help="Directory with reference voice samples")
    parser.add_argument("--output", "-o", help="Output path (without extension; creates .txt and .md)")
    parser.add_argument("--speakers", "-s", type=int, help="Number of speakers (auto-detected if omitted)")
    parser.add_argument("--language", "-l", default="hi", help="Language code (default: hi for Hindi/Hinglish)")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.audio):
        print(f"Error: Audio file not found: {args.audio}", file=sys.stderr)
        sys.exit(1)
    
    if args.references and not os.path.isdir(args.references):
        print(f"Error: References directory not found: {args.references}", file=sys.stderr)
        sys.exit(1)
    
    run_pipeline(
        audio_path=args.audio,
        ref_dir=args.references,
        n_speakers=args.speakers,
        language=args.language,
        output_path=args.output,
    )


if __name__ == "__main__":
    main()
