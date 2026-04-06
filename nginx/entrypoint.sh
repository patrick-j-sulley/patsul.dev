#!/bin/bash
set -e

: "${BACKEND_HOST:?BACKEND_HOST is required}"
: "${BACKEND_PORT:?BACKEND_PORT is required}"
: "${FRONTEND_HOST:?FRONTEND_HOST is required}"
: "${FRONTEND_PORT:?FRONTEND_PORT is required}"

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
export BACKEND_HOST BACKEND_PORT FRONTEND_HOST FRONTEND_PORT NGINX_LISTEN_BLOCK

envsubst '${NGINX_LISTEN_BLOCK} ${BACKEND_HOST} ${BACKEND_PORT} ${FRONTEND_HOST} ${FRONTEND_PORT}' \
  < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

nginx -t
exec nginx -g 'daemon off;'
