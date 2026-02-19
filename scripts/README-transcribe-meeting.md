# Meeting Transcription Pipeline

Transcribes meeting audio with speaker diarization and optional speaker identification via reference voice samples.

## Architecture

| Component | Method | Notes |
|-----------|--------|-------|
| **Transcription** | OpenAI Whisper API | Handles Hindi/Hinglish, word timestamps, no local GPU |
| **Diarization** | MFCC + Agglomerative Clustering | Lightweight, CPU-only, ~50MB RAM |
| **Speaker ID** | Cosine similarity on MFCC embeddings | Matches clusters to reference voices |

## Requirements

- Python 3.11+
- `OPENAI_API_KEY` environment variable set
- ffmpeg installed
- Python packages: `openai`, `pydub`, `numpy`, `scipy`, `scikit-learn`

Install:
```bash
pip3 install --user --break-system-packages openai pydub numpy scipy scikit-learn
```

## Usage

```bash
# Basic transcription (auto-detect speakers)
python3 scripts/transcribe-meeting.py --audio meeting.mp3

# With reference voices for speaker labeling
python3 scripts/transcribe-meeting.py \
  --audio meeting.mp3 \
  --references voice-references/ \
  --output transcripts/meeting-2026-02-19

# Specify number of speakers and language
python3 scripts/transcribe-meeting.py \
  --audio meeting.mp3 \
  --references voice-references/ \
  --speakers 4 \
  --language hi \
  --output transcripts/meeting
```

## Reference Voices

Place labeled audio files in `voice-references/`:
```
voice-references/
  hmt.ogg          → Speaker labeled as "HMT"
  parveen.ogg      → Speaker labeled as "PARVEEN"
  vinay.mp3        → Speaker labeled as "VINAY"
```

The filename (without extension) becomes the speaker label. Supports: `.wav`, `.ogg`, `.oga`, `.mp3`, `.m4a`, `.flac`, `.opus`.

## Output

Creates both `.txt` and `.md` files:

**Text format:**
```
[00:00] [HMT]
  Toh aaj ka agenda hai ki...

[00:15] [PARVEEN]
  Haan, maine wo report dekhi...
```

**Markdown format:** Structured with headers, timestamps, and speaker labels.

## Limitations (on 2 vCPU / 2GB RAM VPS)

1. **Diarization accuracy**: MFCC-based clustering is less accurate than neural approaches (pyannote.audio). It works well for distinct voices but may struggle with similar-sounding speakers.
2. **No real-time**: Processing is sequential and CPU-bound. A 1-hour meeting takes ~2-5 minutes (mostly API time).
3. **API cost**: Whisper API charges ~$0.006/minute of audio.
4. **File size limit**: OpenAI API accepts max 25MB per request. Larger files are auto-chunked.
5. **Speaker count**: Auto-detection works for 2-6 speakers. For larger meetings, specify `--speakers N`.

## Future Improvements

- Add pyannote.audio support when a GPU-equipped machine is available (much better diarization)
- Add support for streaming/real-time transcription
- Add SRT/VTT subtitle output format
