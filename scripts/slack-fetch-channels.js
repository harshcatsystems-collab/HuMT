const {execSync} = require('child_process');
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('/home/harsh/.openclaw/openclaw.json','utf8'));

// Find bot token
let token = '';
const slack = config.channels?.slack || {};
token = slack.botToken || '';

if (!token) { console.error('No bot token found'); process.exit(1); }

const channels = process.argv.slice(2);
for (const ch of channels) {
  console.log('\n=== ' + ch + ' ===');
  try {
    const r = JSON.parse(execSync(
      `curl -s -H "Authorization: Bearer ${token}" "https://slack.com/api/conversations.history?channel=${ch}&limit=12"`,
      {timeout: 10000}
    ).toString());
    if (r.ok) {
      r.messages.reverse().forEach(m => {
        const t = new Date(m.ts * 1000).toISOString().slice(0, 16);
        console.log(t, m.user || 'bot', (m.text || '').slice(0, 250));
      });
    } else console.log('ERR:', r.error);
  } catch(e) { console.log('FETCH ERR:', e.message.slice(0,100)); }
}
