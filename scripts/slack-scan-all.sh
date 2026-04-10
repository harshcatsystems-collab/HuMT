#!/bin/bash
# Scans Slack channels HMT (U05QMQHCVNY) is a member of.
# Source of truth: users.conversations API, verified 2026-04-10.
# Total: 111 channels. Tiered by relevance to HMT's scope.
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
echo "SLACK SCAN — Last ${HOURS_BACK}h (HMT's 111 channels)"
echo "=========================================="
echo ""

# ━━━ TIER 1: FOUNDERS & STRATEGY ━━━
echo "━━━ TIER 1: FOUNDERS & STRATEGY ━━━"
read_channel "GEJUR0WA2"    "#founders_sync"                         50
read_channel "C085P594G7N"  "#founders-plus"                         50
read_channel "C06C97L05JP"  "#quarterly_investor_updates"            30
read_channel "C073D2D5FRP"  "#pm-only-top-secret"                    50

# ━━━ TIER 1: PRODUCT & GROWTH ━━━
echo "━━━ TIER 1: PRODUCT & GROWTH ━━━"
read_channel "CEWV0GMMG"    "#product"                               50
read_channel "C080EJU9873"  "#growth-pod"                            50
read_channel "C07T7047TEZ"  "#product-growth"                        50
read_channel "C06LLFTK7NK"  "#product-internal"                      50
read_channel "C084ZC2RNUA"  "#product-discussions"                   50
read_channel "C092XDNSDB9"  "#full-funnel-solver"                    50
read_channel "C0ABCG0RV1N"  "#homepage-personalisation"              50
read_channel "C094EJU35L7"  "#biggest-delta"                         30
read_channel "C09GHS9PNPM"  "#mo-conversion-drop"                    30
read_channel "C0AH5AVJ5PV"  "#growtht-tracker"                       30
read_channel "C09PM1DNK34"  "#growth-clm"                            20

# ━━━ TIER 1: RETENTION & LIFECYCLE ━━━
echo "━━━ TIER 1: RETENTION & LIFECYCLE ━━━"
read_channel "C06QTJMKLUA"  "#retention"                             50
read_channel "C0A5GJRCQTZ"  "#m1-watchers-retention"                 50
read_channel "C0A6ZPA3XT8"  "#m0-strategy"                           50
read_channel "C0AAKDTMY82"  "#retention_cost_optimization"           30
read_channel "C0A2QNQSA0P"  "#dormant-resurrection"                  50
read_channel "C0914FW9WE9"  "#user_activation"                       50
read_channel "C07TTQQL8JU"  "#user-activation-strategy"              50
read_channel "C0904NE9Y2K"  "#engagement-solver-team"                50
read_channel "C0AK6NSDHFH"  "#watch-retention-solver"                50
read_channel "C09FW03KB2S"  "#maha-punarjanam"                       30

# ━━━ TIER 1: CONTENT & INSIGHTS ━━━
echo "━━━ TIER 1: CONTENT & INSIGHTS ━━━"
read_channel "C08HQ89S797"  "#content_strategy"                      50
read_channel "C076AUFK74Z"  "#content-product-jugalbandi"            30
read_channel "C0A07SN8C6N"  "#content-title-stack"                   30
read_channel "CS75DM3KQ"    "#stage-product-feedback-and-requests"   30
read_channel "C07RVS92YT0"  "#research_updates"                      30
read_channel "C09PWTHF44A"  "#building-consumer-insights-team"       30
read_channel "C05S2L634EB"  "#user-feedbacks"                        30
read_channel "C05BQLDB1SM"  "#content-categorization"                20

# ━━━ TIER 1: AI & INNOVATION ━━━
echo "━━━ TIER 1: AI & INNOVATION ━━━"
read_channel "C08PY53QYSU"  "#ai-at-stage"                           50
read_channel "C0AFKKM6Y5C"  "#ai-character-bots"                     50
read_channel "C0AFDSFD3PA"  "#ai-native-agentic-framework-content"   30
read_channel "C0ADHK6L2P3"  "#ai-trailer-generator"                  30
read_channel "C0ANVN4DXHS"  "#agentic-perf-marketing"                30
read_channel "C08BPD4FJHH"  "#stage-ai"                              30
read_channel "C0AL2NUKAP7"  "#cricket-saathi"                        30
read_channel "C0AD3A70VRU"  "#1user_1agent"                          20

# ━━━ TIER 2: PEOPLE & CULTURE ━━━
echo "━━━ TIER 2: PEOPLE & CULTURE ━━━"
read_channel "C082Z8FUBRV"  "#all-things-people-and-culture"         30
read_channel "C084HQGH9T6"  "#managers-aspiring-to-be-leaders"       30
read_channel "C08QQQ8T7C2"  "#competency-framework"                  20
read_channel "C087DEHCF8T"  "#skill-framework"                       20
read_channel "C09FVFY0P5F"  "#performance-management-framework"      20
read_channel "C086EJ905FB"  "#team-hr"                               20
read_channel "C0AEG5645RT"  "#culture-productising"                  20
read_channel "C083G6MMJ0K"  "#small-wins"                            20

# ━━━ TIER 2: MONETISATION & FINANCE ━━━
echo "━━━ TIER 2: MONETISATION & FINANCE ━━━"
read_channel "C0A87E17UMS"  "#monetisation"                          50
read_channel "C0A4BF8HTN3"  "#monetisation-core-devs"                30
read_channel "C08PGK8CM32"  "#finance-department"                    30
read_channel "C08GL5NN7MK"  "#stage_legal-and-finance"               20
read_channel "C084TNRH7QE"  "#daily-cac"                             30
read_channel "C084JVD7Q68"  "#referrals"                             20

# ━━━ TIER 2: TECH & DATA ━━━
echo "━━━ TIER 2: TECH & DATA ━━━"
read_channel "CEHPPGSN9"    "#tech-mates"                            30
read_channel "C085HDR1BS4"  "#tech-product-updates"                  20
read_channel "C07SXBJTZJ7"  "#team-data"                             20
read_channel "C07N3RN9FH7"  "#recommendation-engine"                 20
read_channel "C07DC1S9JQ1"  "#proj-analytics-infra"                  20
read_channel "C08KMK43JN6"  "#release-cycle"                         20
read_channel "C06PD3K9TN2"  "#project-mobile-continuous-delivery"    20
read_channel "C07JLD7JL0P"  "#playstore-ratings"                     20

# ━━━ TIER 2: CONTENT PRODUCTION ━━━
echo "━━━ TIER 2: CONTENT PRODUCTION ━━━"
read_channel "C0AKJCKC45D"  "#film-pod-stage"                        30
read_channel "C0AFJCPPG8P"  "#long-binge-series-pod"                 30
read_channel "C0AD10E31CH"  "#micro-drama-central-pod-stage"         30
read_channel "C0AFZSHT7D0"  "#microdrama-promo-pod"                  20
read_channel "C090SNCDT8T"  "#project-reels-and-microdramas"         20
read_channel "C08AM06AMRC"  "#mini-to-main-migration"                20
read_channel "C08GCK3BTFF"  "#ai4stage-user-interviews"              20
read_channel "C08CM57S4CC"  "#cinema-discussion-and-appreciation"    20
read_channel "C0800A3GERY"  "#stage-content-growth"                  20
read_channel "C08K7RS42RM"  "#media-mentions"                        20
read_channel "C04H5RF55RQ"  "#content-notification"                  20
read_channel "C08G27WDN4S"  "#conversion-survey"                     20

# ━━━ TIER 2: REGIONAL ━━━
echo "━━━ TIER 2: REGIONAL ━━━"
read_channel "C0810CKG1C1"  "#bhojpuri_stage"                        20
read_channel "C0A7QKTFCDN"  "#gujarati_stage"                        20
read_channel "C08K5MP861W"  "#cms-stage"                             20

# ━━━ TIER 2: HIRING ━━━
echo "━━━ TIER 2: HIRING ━━━"
read_channel "C095EKEC0LX"  "#hiring-approval"                       30
read_channel "C08QC5UHQUS"  "#productgrowth-hiring"                  20
read_channel "C079LSSQA0Y"  "#product-and-analytics-hiring"          20
read_channel "C09TLDLA7GE"  "#retention-hiring"                      20

# ━━━ TIER 3: COMPANY PULSE ━━━
echo "━━━ TIER 3: COMPANY PULSE ━━━"
read_channel "CDZFAJLBV"    "#announcements"                         20
read_channel "CEHPZTVD3"    "#stage-ke-krantikaari"                  20
read_channel "C08AY77063V"  "#weekly-mis"                            20
read_channel "C06GK2M36P9"  "#company-imp-docs"                      20
read_channel "C08MGJRDTEW"  "#tv-adoption"                           20
read_channel "C047HLH7T26"  "#promo-team"                            20
read_channel "C093EC443K5"  "#socials-team"                          20
read_channel "C082STFKC5V"  "#team-brand"                            20
read_channel "C0A8EJR4J7L"  "#trendingstories"                       20
read_channel "C09PDC19QJE"  "#randeep-hooda"                         20
read_channel "C0A4LRBCLQ2"  "#watch-along"                           20
read_channel "C0A75FY5RMJ"  "#stage-vip-club"                        20
read_channel "C08KGJ3GG4B"  "#stage-xrmedia"                         20
read_channel "C07KWTTB98W"  "#stage_maino"                           20
read_channel "C0602HW0Z5M"  "#stageisset"                            20
read_channel "C0A8JDHNKHC"  "#baahubali-squad"                       20
read_channel "C084EE30XPD"  "#random-ideas"                          20

# ━━━ TIER 3: ADMIN / OPS ━━━
echo "━━━ TIER 3: ADMIN / OPS ━━━"
read_channel "C06L5FQL3GU"  "#credit_card_invoices"                  20
read_channel "C08HKLHM7AN"  "#founder-travel"                        20
read_channel "C0AL9G2CH7S"  "#tam-expansion-dubbing"                 20
read_channel "C0ALBB1G7RD"  "#subscription-ads-feature-film"         20
read_channel "C08KU4RJAFN"  "#muhurat-scenes"                        20
read_channel "C07KPJ37SGL"  "#due-deligence-requirement"             20
read_channel "C08CXKGUV5Z"  "#harsh-reimbursement"                   20
read_channel "C064K7EGWUT"  "#hr-invoice"                            20
read_channel "C03C4QAPABU"  "#leave-intimation"                      20
read_channel "C081K05ULR2"  "#new-office"                            20
read_channel "C05LT4FT4A3"  "#product-invoices"                      20
read_channel "C0765HXVBFB"  "#project-streamline-new-employee-onboarding" 20
