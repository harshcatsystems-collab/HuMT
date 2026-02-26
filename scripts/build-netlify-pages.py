#!/usr/bin/env python3
"""Convert markdown files to styled HTML presentations for Netlify."""
import re, os

STYLE = """
<style>
body { font-family: 'Google Sans', Arial, sans-serif; max-width: 900px; margin: 40px auto; color: #1a1a1a; line-height: 1.6; padding: 0 20px; }
h1 { font-size: 28px; border-bottom: 3px solid #1a73e8; padding-bottom: 12px; margin-top: 48px; }
h2 { font-size: 22px; color: #1a73e8; margin-top: 40px; border-bottom: 1px solid #e0e0e0; padding-bottom: 8px; }
h3 { font-size: 17px; color: #333; margin-top: 24px; }
h4 { font-size: 15px; color: #555; margin-top: 20px; }
table { border-collapse: collapse; width: 100%; margin: 16px 0; font-size: 14px; }
th { background: #1a73e8; color: white; padding: 10px 14px; text-align: left; font-weight: 600; }
td { padding: 8px 14px; border-bottom: 1px solid #e8e8e8; }
tr:nth-child(even) td { background: #f8f9fa; }
.callout { background: #fef7e0; border-left: 4px solid #f9ab00; padding: 16px 20px; margin: 20px 0; border-radius: 0 8px 8px 0; }
.callout-red { background: #fce8e6; border-left: 4px solid #d93025; padding: 16px 20px; margin: 20px 0; border-radius: 0 8px 8px 0; }
.callout-green { background: #e6f4ea; border-left: 4px solid #34a853; padding: 16px 20px; margin: 20px 0; border-radius: 0 8px 8px 0; }
blockquote { border-left: 3px solid #1a73e8; margin: 16px 0; padding: 8px 16px; color: #444; font-style: italic; background: #f8f9fa; border-radius: 0 8px 8px 0; }
code { background: #f1f3f4; padding: 2px 6px; border-radius: 4px; font-size: 13px; }
pre { background: #f1f3f4; padding: 16px; border-radius: 8px; overflow-x: auto; font-size: 13px; }
.subtitle { color: #666; font-size: 16px; margin-top: -8px; }
.tag { display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 700; color: white; margin-right: 6px; }
.footer { color: #999; margin-top: 48px; font-size: 13px; border-top: 1px solid #e8e8e8; padding-top: 16px; }
ul, ol { margin: 12px 0; }
li { margin: 4px 0; }
strong { color: #1a1a1a; }
hr { border: none; border-top: 1px solid #e8e8e8; margin: 32px 0; }
</style>
"""

def md_to_html(md_text, title, subtitle=""):
    html = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>{title}</title>
{STYLE}
</head>
<body>
<h1>{title}</h1>
"""
    if subtitle:
        html += f'<p class="subtitle">{subtitle}</p>\n'
    
    lines = md_text.split('\n')
    in_list = False
    in_ol = False
    in_table = False
    in_code = False
    in_blockquote = False
    
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        
        # Code blocks
        if stripped.startswith('```'):
            if in_code:
                html += "</pre>\n"
                in_code = False
            else:
                if in_list: html += "</ul>\n"; in_list = False
                if in_ol: html += "</ol>\n"; in_ol = False
                html += "<pre>"
                in_code = True
            i += 1
            continue
        
        if in_code:
            html += line.replace('<', '&lt;').replace('>', '&gt;') + '\n'
            i += 1
            continue
        
        # Blockquotes
        if stripped.startswith('> '):
            if in_list: html += "</ul>\n"; in_list = False
            if in_ol: html += "</ol>\n"; in_ol = False
            if in_table: html += "</table>\n"; in_table = False
            content = stripped[2:]
            content = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', content)
            content = re.sub(r'\*(.+?)\*', r'<em>\1</em>', content)
            if not in_blockquote:
                html += "<blockquote>"
                in_blockquote = True
            html += content + "<br>"
            i += 1
            continue
        elif in_blockquote:
            html += "</blockquote>\n"
            in_blockquote = False
        
        # Headers (skip first h1, we already have title)
        if stripped.startswith('# ') and i < 3:
            i += 1
            continue
        if stripped.startswith('#### '):
            if in_list: html += "</ul>\n"; in_list = False
            if in_ol: html += "</ol>\n"; in_ol = False
            if in_table: html += "</table>\n"; in_table = False
            html += f"<h4>{stripped[5:]}</h4>\n"
            i += 1
            continue
        if stripped.startswith('### '):
            if in_list: html += "</ul>\n"; in_list = False
            if in_ol: html += "</ol>\n"; in_ol = False
            if in_table: html += "</table>\n"; in_table = False
            html += f"<h3>{stripped[4:]}</h3>\n"
            i += 1
            continue
        if stripped.startswith('## '):
            if in_list: html += "</ul>\n"; in_list = False
            if in_ol: html += "</ol>\n"; in_ol = False
            if in_table: html += "</table>\n"; in_table = False
            html += f"<h2>{stripped[3:]}</h2>\n"
            i += 1
            continue
        if stripped.startswith('# '):
            if in_list: html += "</ul>\n"; in_list = False
            if in_ol: html += "</ol>\n"; in_ol = False
            if in_table: html += "</table>\n"; in_table = False
            html += f"<h2>{stripped[2:]}</h2>\n"
            i += 1
            continue
        
        # Horizontal rules
        if stripped in ('---', '***', '___'):
            if in_list: html += "</ul>\n"; in_list = False
            if in_ol: html += "</ol>\n"; in_ol = False
            if in_table: html += "</table>\n"; in_table = False
            html += "<hr>\n"
            i += 1
            continue
        
        # Table rows
        if '|' in stripped and stripped.startswith('|'):
            cells = [c.strip() for c in stripped.split('|')[1:-1]]
            if all(set(c) <= set('- :') for c in cells):
                i += 1
                continue
            if not in_table:
                if in_list: html += "</ul>\n"; in_list = False
                if in_ol: html += "</ol>\n"; in_ol = False
                html += "<table>\n"
                in_table = True
                # First row = header
                html += "<tr>" + "".join(f"<th>{c}</th>" for c in cells) + "</tr>\n"
                i += 1
                continue
            for ci in range(len(cells)):
                cells[ci] = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', cells[ci])
                cells[ci] = re.sub(r'\*(.+?)\*', r'<em>\1</em>', cells[ci])
            html += "<tr>" + "".join(f"<td>{c}</td>" for c in cells) + "</tr>\n"
            i += 1
            continue
        elif in_table:
            html += "</table>\n"
            in_table = False
        
        # Ordered list
        if re.match(r'^\d+[\.\)] ', stripped):
            if in_list: html += "</ul>\n"; in_list = False
            if not in_ol:
                html += "<ol>\n"
                in_ol = True
            content = re.sub(r'^\d+[\.\)] ', '', stripped)
            content = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', content)
            content = re.sub(r'\*(.+?)\*', r'<em>\1</em>', content)
            content = re.sub(r'`(.+?)`', r'<code>\1</code>', content)
            html += f"<li>{content}</li>\n"
            i += 1
            continue
        
        # Unordered list
        if stripped.startswith('- ') or stripped.startswith('* '):
            if in_ol: html += "</ol>\n"; in_ol = False
            if not in_list:
                html += "<ul>\n"
                in_list = True
            content = stripped[2:]
            content = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', content)
            content = re.sub(r'\*(.+?)\*', r'<em>\1</em>', content)
            content = re.sub(r'`(.+?)`', r'<code>\1</code>', content)
            html += f"<li>{content}</li>\n"
            i += 1
            continue
        
        # Empty line
        if stripped == '':
            if in_list: html += "</ul>\n"; in_list = False
            if in_ol: html += "</ol>\n"; in_ol = False
            i += 1
            continue
        
        # Regular paragraph
        if in_list: html += "</ul>\n"; in_list = False
        if in_ol: html += "</ol>\n"; in_ol = False
        content = stripped
        content = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', content)
        content = re.sub(r'\*(.+?)\*', r'<em>\1</em>', content)
        content = re.sub(r'`(.+?)`', r'<code>\1</code>', content)
        content = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', content)
        html += f"<p>{content}</p>\n"
        i += 1
    
    if in_list: html += "</ul>\n"
    if in_ol: html += "</ol>\n"
    if in_table: html += "</table>\n"
    if in_blockquote: html += "</blockquote>\n"
    
    html += '\n<div class="footer">Built by 🥚 HuMT | For internal use only</div>\n</body>\n</html>'
    return html

# Files to convert
BASE = '/home/harsh/.openclaw/workspace'
SERVE = f'{BASE}/data/serve'

pages = [
    # Meeting Digests
    (f"{BASE}/research/content-strategy-2.0-final.md", 
     "content-strategy-2.0.html",
     "Content Strategy 2.0 — Consolidated Meeting Notes",
     "Feb 23, 2026 · 105-min meeting · All co-founders + content team"),
    
    (f"{BASE}/research/content-strategy-2.0-decision-catalog.md",
     "content-strategy-decisions.html", 
     "Content Strategy 2.0 — Decision Catalog",
     "33 decisions tracked · Feb 19 → Feb 23 evolution"),
    
    (f"{BASE}/research/content-strategy-meeting-feb19-analysis.md",
     "content-strategy-feb19.html",
     "Content Strategy Meeting — Analysis & Insights (Feb 19)",
     "First content strategy meeting · Foundation for 2.0"),
    
    (f"{BASE}/research/series-c-vivek-call-feb24.md",
     "series-c-vivek-call.html",
     "Series C Deck Review — Vinay × Vivek (Goodwater)",
     "Feb 24, 2026 · 1-hour call · Deck feedback + AI progress + Alteria debt"),
    
    (f"{BASE}/research/manasvi-work-vs-live-data-analysis.md",
     "manasvi-data-alignment.html",
     "Manasvi Work vs Live Data — Alignment Analysis",
     "Feb 19, 2026 · HP Personalisation data audit"),
    
    (f"{BASE}/research/stage-retention-board-deck-jan26.md",
     "retention-board-deck.html",
     "Retention Board Deck (Jan 2026) — Ingestion & Analysis",
     "Board review deck · Competitive benchmarks · M1→M3 cliff analysis"),
    
    (f"{BASE}/research/blume-meetings-context.md",
     "blume-context.html",
     "Blume Ventures — Meeting Context & Intelligence",
     "Monthly catchup context · Marmik Mankodi insights"),
    
    # Fundraise
    (f"{BASE}/research/series-c-fundraise.md",
     "series-c-master.html",
     "Series C Fundraise — Master Context",
     "Complete fundraise context · Goodwater + Blume · Terms + strategy"),
    
    # Data Infrastructure
    (f"{BASE}/research/metabase-catalog.md",
     "metabase-catalog.html",
     "Metabase Dashboard Catalog",
     "Complete catalog of STAGE Metabase dashboards · 50+ dashboards mapped"),
    
    (f"{BASE}/research/snowflake-deep-analysis.md",
     "snowflake-analysis.html",
     "Snowflake Data Infrastructure — Deep Analysis",
     "Data warehouse architecture · Tables, schemas, query patterns"),
    
    (f"{BASE}/research/dbt-data-model.md",
     "dbt-model.html",
     "dbt Data Model — STAGE Analytics",
     "Data transformation layer · Models, dependencies, lineage"),
    
    (f"{BASE}/research/cms-intelligence-system.md",
     "cms-intelligence.html",
     "CMS Intelligence System",
     "Content management system analysis · 1,256 titles · API mapping"),
]

for src_path, out_name, title, subtitle in pages:
    if os.path.exists(src_path):
        with open(src_path) as f:
            md = f.read()
        html = md_to_html(md, title, subtitle)
        out_path = os.path.join(SERVE, out_name)
        with open(out_path, 'w') as f:
            f.write(html)
        print(f"✅ {out_name} ({len(html):,} bytes)")
    else:
        print(f"❌ {src_path} not found")

print(f"\nDone! {len(pages)} pages built.")
