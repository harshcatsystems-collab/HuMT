const fs = require('fs');
const data = fs.readFileSync(process.argv[2], 'utf8');

const tracked = {
  'U08L99D58PK': 'Nikhil Nair',
  'U0719V1GX3Q': 'Pranay Merchant',
  'U04A980D1N3': 'Ashish Pandey',
  'U08UL9EHKKP': 'Samir Kumar',
  'U08KBHHV9J4': 'Radhika Vijay',
  'U07R906K9K5': 'Nishita Banerjee',
  'U07LFSB0PM5': 'Vismit Bansal',
  'U068F2RS5PV': 'Nisha Ali',
  'UEHET2Q2G': 'Vinay Singhal',
  'UEJV57HQW': 'Parveen Singhal',
  'UE0KTBS8P': 'Shashank Vaishnav'
};

const activity = {};

// Parse all JSON objects
const lines = data.trim().split('\n').filter(l => l.trim());
for (const line of lines) {
  try {
    const msg = JSON.parse(line);
    const userId = msg.user;
    
    if (!tracked[userId]) continue;
    
    if (!activity[userId]) {
      activity[userId] = {
        messages: 0,
        thread_replies: 0,
        channels: new Set(),
        channel_ids: new Set(),
        after_hours: 0,
        response_latencies: []
      };
    }
    
    const act = activity[userId];
    const ts = parseFloat(msg.ts);
    const threadTs = msg.thread_ts ? parseFloat(msg.thread_ts) : null;
    
    // Count messages vs thread replies
    if (!threadTs || threadTs === ts) {
      act.messages++;
    } else {
      act.thread_replies++;
      act.response_latencies.push(ts - threadTs);
    }
    
    act.channel_ids.add(msg.channel);
    
    // Check after hours (IST = UTC+5:30)
    const date = new Date(ts * 1000);
    const istHour = (date.getUTCHours() + 5 + Math.floor((date.getUTCMinutes() + 30) / 60)) % 24;
    if (istHour < 9 || istHour >= 19) {
      act.after_hours++;
    }
  } catch (e) {
    // Skip malformed lines
  }
}

// Output JSONL
const now = new Date().toISOString();
const output = [];

for (const [userId, act] of Object.entries(activity)) {
  const avgLatency = act.response_latencies.length > 0
    ? Math.round(act.response_latencies.reduce((a, b) => a + b, 0) / act.response_latencies.length)
    : null;
  
  output.push(JSON.stringify({
    ts: now,
    user: userId,
    name: tracked[userId],
    messages: act.messages,
    thread_replies: act.thread_replies,
    channels_active: act.channel_ids.size,
    channel_ids: Array.from(act.channel_ids),
    after_hours: act.after_hours,
    avg_response_latency_sec: avgLatency
  }));
}

// Add run marker
output.push(JSON.stringify({
  ts: now,
  _type: 'logger_run',
  people_tracked: 11
}));

console.log(output.join('\n'));
