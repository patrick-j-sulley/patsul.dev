#!/bin/bash
set -e

: "${BACKEND_HOST:?BACKEND_HOST is required}"
: "${BACKEND_PORT:?BACKEND_PORT is required}"
: "${FRONTEND_HOST:?FRONTEND_HOST is required}"
: "${FRONTEND_PORT:?FRONTEND_PORT is required}"

# Explicitly export all four routing variables so envsubst inherits them.
export BACKEND_HOST="$BACKEND_HOST"
export BACKEND_PORT="$BACKEND_PORT"
export FRONTEND_HOST="$FRONTEND_HOST"
export FRONTEND_PORT="$FRONTEND_PORT"

# Railway often forwards to $PORT (e.g. 8080) while the public URL shows :80. Bind 80 + PORT when PORT≠80.
# If PORT is unset/empty, bind 80 and 8080 so the edge still finds a listener (compose sets PORT=80 explicitly).
if [ -n "$PORT" ]; then
  if [ "$PORT" = "80" ]; then
    NGINX_LISTEN_BLOCK="    listen 80;"
  else
    NGINX_LISTEN_BLOCK="    listen 80;
    listen ${PORT};"
  fi
else
  NGINX_LISTEN_BLOCK="    listen 80;
    listen 8080;"
fi
export NGINX_LISTEN_BLOCK

# Step 1: substitute the four routing variables using an explicit variable list.
# Passing NGINX_LISTEN_BLOCK (which contains newlines) in the envsubst filter
# string can confuse some envsubst builds, so handle it in a separate pass.
envsubst '${BACKEND_HOST} ${BACKEND_PORT} ${FRONTEND_HOST} ${FRONTEND_PORT}' \
  < /etc/nginx/nginx.conf.template \
  | envsubst '${NGINX_LISTEN_BLOCK}' \
  > /etc/nginx/conf.d/default.conf

echo "--- Generated /etc/nginx/conf.d/default.conf ---"
cat /etc/nginx/conf.d/default.conf
echo "-------------------------------------------------"

nginx -t
exec nginx -g 'daemon off;'
