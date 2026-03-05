#!/bin/bash
# Upload HTML file to Google Drive as a Google Doc
# Usage: ./upload-html-to-gdocs.sh <html-file> <title> <parent-folder-id>

HTML_FILE="$1"
TITLE="$2"
PARENT_ID="$3"

if [[ -z "$HTML_FILE" || -z "$TITLE" || -z "$PARENT_ID" ]]; then
    echo "Usage: $0 <html-file> <title> <parent-folder-id>"
    exit 1
fi

if [[ ! -f "$HTML_FILE" ]]; then
    echo "Error: File not found: $HTML_FILE"
    exit 1
fi

# Get OAuth token from gog (assumes gog is configured)
TOKEN=$(~/go/bin/gog drive list --json --no-input 2>/dev/null | jq -r '.token // empty')

if [[ -z "$TOKEN" ]]; then
    echo "Error: Could not get OAuth token from gog"
    exit 1
fi

# Create metadata JSON
METADATA=$(cat <<EOF
{
  "name": "$TITLE",
  "parents": ["$PARENT_ID"],
  "mimeType": "application/vnd.google-apps.document"
}
EOF
)

# Upload using multipart upload
BOUNDARY="==BOUNDARY=="

RESPONSE=$(curl -s -X POST \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: multipart/related; boundary=$BOUNDARY" \
  --data-binary @- <<MULTIPART
--$BOUNDARY
Content-Type: application/json; charset=UTF-8

$METADATA
--$BOUNDARY
Content-Type: text/html

$(cat "$HTML_FILE")
--$BOUNDARY--
MULTIPART
)

# Extract file ID from response
FILE_ID=$(echo "$RESPONSE" | jq -r '.id // empty')

if [[ -n "$FILE_ID" ]]; then
    echo "✓ Uploaded to Google Docs: https://docs.google.com/document/d/$FILE_ID/edit"
    echo "$FILE_ID"
    exit 0
else
    echo "✗ Upload failed"
    echo "$RESPONSE" | jq '.'
    exit 1
fi
