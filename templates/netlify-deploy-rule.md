# Netlify Deployment Rule — MANDATORY

## For Sub-Agents and All Sessions

**NEVER deploy to Netlify using direct API calls.**

**ALWAYS use:**
```bash
bash scripts/deploy-presentation.sh <filename.html>
```

**Why:** Direct API calls with single-file manifests will DELETE all other files from the site.

**The script does:**
1. Validates file exists and is linked in index.html
2. Builds manifest of ALL files (not just new one)
3. Deploys full manifest to Netlify
4. Verifies deployment with health check
5. Uploads to Google Drive if folder specified

**If the script fails:** Report error to main agent. Do NOT bypass it with direct API calls.

**Example:**
```bash
bash scripts/deploy-presentation.sh m0-engagement-v2.html strategy
```

This is non-negotiable.
