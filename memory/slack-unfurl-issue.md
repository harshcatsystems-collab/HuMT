# Slack Bot Unfurl Issue

**Problem:** HuMT bot messages don't generate link preview cards (but user messages do)

**Root Cause:** Bot app missing `links:write` OAuth scope

**Solution:**
1. Visit https://api.slack.com/apps → Select STAGE HuMT app
2. OAuth & Permissions → Bot Token Scopes
3. Add `links:write` scope
4. Reinstall app to workspace

**Workaround:** 
- Set `unfurl_links: true` in chat.postMessage calls (doesn't work without scope)
- Or have HMT post links when previews are critical

**Tested:** March 3, 2026 — confirmed unfurl_links parameter doesn't work without OAuth scope

**Status:** Needs Slack app admin access to fix
