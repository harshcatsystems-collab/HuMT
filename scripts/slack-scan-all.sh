#!/bin/bash
# Scans all tiered Slack channels and outputs formatted summaries
# Usage: slack-scan-all.sh [hours_back]
# Default: 24 hours back

HOURS_BACK="${1:-24}"
OLDEST=$(python3 -c "import time; print(int(time.time()) - ${HOURS_BACK}*3600)")

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

read_channel() {
    local ch_id="$1"
    local ch_name="$2"
    local limit="$3"
    
    local result=$(curl -s -H "Authorization: Bearer $BOT_TOKEN" \
        "https://slack.com/api/conversations.history?channel=${ch_id}&limit=${limit}&oldest=${OLDEST}")
    
    local count=$(echo "$result" | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d.get('messages',[])))" 2>/dev/null)
    
    if [ "$count" != "0" ]; then
        echo "=== ${ch_name} (${ch_id}) — ${count} messages ==="
        echo "$result" | python3 -c "
import json,sys,datetime
SKIP_SUBTYPES = {'channel_join','channel_leave','channel_purpose','channel_topic','channel_name','channel_archive','channel_unarchive','bot_add','bot_remove','group_join','group_leave'}
d=json.load(sys.stdin)
if d.get('ok'):
    for m in reversed(d.get('messages',[])):
        if m.get('subtype','') in SKIP_SUBTYPES:
            continue
        ts = datetime.datetime.fromtimestamp(float(m.get('ts',0))).strftime('%H:%M')
        user = m.get('user','bot')
        text = m.get('text','').replace('\n',' ')[:200]
        print(f'  {ts} | {user} | {text}')
else:
    print(f'  ERROR: {d.get(\"error\",\"unknown\")}')
" 2>/dev/null
        echo ""
    fi
}

echo "=========================================="
echo "SLACK SCAN — Last ${HOURS_BACK}h"
echo "=========================================="
echo ""

echo "━━━ TIER 1: PRODUCT ━━━"
read_channel "CEWV0GMMG" "#product" 50
read_channel "C080EJU9873" "#growth-pod" 50
read_channel "C07T7047TEZ" "#product-growth" 50
read_channel "C035F6W8DK9" "#product-design" 50
read_channel "C0368KVCL2D" "#product-analytics" 50
read_channel "C035QJ5A8G6" "#product_prd" 50
read_channel "C08N82UFN3F" "#productdesign" 50
read_channel "C06LLFTK7NK" "#product-internal" 50
read_channel "C084ZC2RNUA" "#product-discussions" 50
read_channel "C073D2D5FRP" "#pm-only-top-secret" 50

echo "━━━ TIER 1: FOUNDERS ━━━"
read_channel "GEJUR0WA2" "#founders_sync" 50
read_channel "C085P594G7N" "#founders-plus" 50
read_channel "C06C97L05JP" "#quarterly_investor_updates" 30

echo "━━━ TIER 1: RETENTION & LIFECYCLE ━━━"
read_channel "C06QTJMKLUA" "#retention" 50
read_channel "C0A3N67V0G2" "#retention-pod" 50
read_channel "C0A5GJRCQTZ" "#m1-watchers-retention" 50
read_channel "C0A6ZPA3XT8" "#m0-strategy" 50
read_channel "C0AAKDTMY82" "#retention_cost_optimization" 30
read_channel "C0A2QNQSA0P" "#dormant-resurrection" 50
read_channel "C0914FW9WE9" "#user_activation" 50
read_channel "C07TTQQL8JU" "#user-activation-strategy" 50
read_channel "C094EJU35L7" "#biggest-delta" 30
read_channel "C081AG7J7EC" "#retention_nikhil" 30
read_channel "C08SAF7RBUZ" "#project_data-active-subscriber-watch-retention" 30
read_channel "C08NV50KE7Q" "#content_writing_retention" 30
read_channel "C07QVKNB16C" "#retention-_-creative" 30
read_channel "C07QSGLSK97" "#copy--retention" 30

echo "━━━ TIER 1: ACQUISITION & GROWTH ━━━"
read_channel "C092XDNSDB9" "#acquisition-pod" 50
read_channel "C0904NE9Y2K" "#engagement-solver-team" 50
read_channel "C09PM1DNK34" "#growth-clm" 50
read_channel "C07N9G9LH0B" "#reengagement-pf-ads-creatives" 30
read_channel "C0905UNGLJK" "#brand-health-funnel-metrics" 30
read_channel "C09DKG689HR" "#paywall-creation" 30

echo "━━━ TIER 1: PEOPLE & CULTURE ━━━"
read_channel "C082Z8FUBRV" "#all-things-people-and-culture" 50
read_channel "C084HQGH9T6" "#managers-aspiring-to-be-leaders" 30
read_channel "C0765HXVBFB" "#project-streamline-new-employee-onboarding" 30
read_channel "C0AEG5645RT" "#culture-productising" 30

echo "━━━ TIER 1: CONSUMER INSIGHTS & RESEARCH ━━━"
read_channel "C09PWTHF44A" "#building-consumer-insights-team" 30
read_channel "C097XAP8493" "#user-research-lab" 30
read_channel "C07RVS92YT0" "#research_updates" 50
read_channel "C08G27WDN4S" "#conversion-survey" 30

echo "━━━ TIER 1: CONTENT STRATEGY ━━━"
read_channel "C08HQ89S797" "#content_strategy" 50
read_channel "C0800A3GERY" "#stage-content-growth" 30
read_channel "C0A07SN8C6N" "#content-title-stack" 30
read_channel "C076AUFK74Z" "#content-product-jugalbandi" 50
read_channel "C090SNCDT8T" "#project-reels-and-microdramas" 30
read_channel "C090D5UJFM4" "#team-bhojpuri" 30
read_channel "C05BQLDB1SM" "#content-categorization" 30

echo "━━━ TIER 1: CROSS-ORG STRATEGY ━━━"
read_channel "C08AY77063V" "#stage-ai" 30
read_channel "C08BPD4FJHH" "#weekly-mis" 30
read_channel "C08K7RS42RM" "#media-mentions" 30
read_channel "C08GL5NN7MK" "#stage_legal-and-finance" 30
read_channel "C06GK2M36P9" "#company-imp-docs" 30
read_channel "C09FW03KB2S" "#maha-punarjanam" 30
read_channel "C0A87E17UMS" "#monetisation" 50
read_channel "C0A4BF8HTN3" "#monetisation-core" 50
read_channel "C07N3RN9FH7" "#recommendation-engine" 30
read_channel "C08AM06AMRC" "#mini-to-main-migration" 30
read_channel "C0A8JDHNKHC" "#baahubali-squad" 30

echo "━━━ TIER 2: HIRING ━━━"
read_channel "C095EKEC0LX" "#hiring-approval" 30
read_channel "C08QC5UHQUS" "#productgrowth-hiring" 20
read_channel "C079LSSQA0Y" "#product-and-analytics-hiring" 20
read_channel "C09TLDLA7GE" "#retention-hiring" 20
read_channel "C04DKHJKV5W" "#tech-hiring" 20

echo "━━━ TIER 2: TECH ━━━"
read_channel "CEHPPGSN9" "#tech-mates" 30
read_channel "C06NYMGLNGH" "#tech-frontend" 20
read_channel "C07CU8W8R5H" "#tech-growth" 20
read_channel "C07TNBUAWPP" "#tech-mobile" 20
read_channel "C07SXBJTZJ7" "#team-data" 20
read_channel "C08L4EMHR0X" "#team-devops" 20
read_channel "C08KMK43JN6" "#release-cycle" 20
read_channel "C07DC1S9JQ1" "#proj-analytics-infra" 20

echo "━━━ TIER 2: REGIONAL & MARKETING ━━━"
read_channel "C02178ASC4X" "#haryanvi_stage" 20
read_channel "C039S74GNP2" "#rajasthani_stage" 20
read_channel "C0810CKG1C1" "#bhojpuri_stage" 20
read_channel "CS75DM3KQ" "#stage-product-feedback-and-requests" 20
read_channel "C037H0GLYP4" "#marketing" 20
read_channel "C047HLH7T26" "#promo-team" 20

echo "━━━ TIER 2: OTHER ━━━"
read_channel "C08E6782AKT" "#proj-onboarding" 20
read_channel "C06L5FQL3GU" "#credit_card_invoices" 20
read_channel "C08PGK8CM32" "#finance-department" 20
read_channel "C08HKLHM7AN" "#founder-travel" 20
read_channel "C07MZ6YVDPS" "#cre-engagement-campaign-rcs-wa" 20
read_channel "C093EC443K5" "#socials-team" 20
read_channel "C082STFKC5V" "#team-brand" 20
read_channel "C08Q2MSCEB1" "#reel-format" 20

echo "━━━ TIER 3: COMPANY PULSE ━━━"
read_channel "CEHPZTVD3" "#stage-ke-krantikaari" 20
read_channel "CDZFAJLBV" "#announcements" 20
