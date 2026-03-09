#!/bin/bash
# Wrapper script that starts gateway with increased SIGINT listener limit

# Set Node.js to allow more event listeners (prevents the leak from freezing us)
export NODE_OPTIONS="--max-old-space-size=2048"

# Start the actual gateway
exec /usr/bin/openclaw gateway start
