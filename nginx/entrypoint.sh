#!/bin/bash
set -e

: "${BACKEND_HOST:?BACKEND_HOST is required}"
: "${BACKEND_PORT:?BACKEND_PORT is required}"
: "${FRONTEND_HOST:?FRONTEND_HOST is required}"
: "${FRONTEND_PORT:?FRONTEND_PORT is required}"

# Railway sets PORT for the public HTTP listener; default 80 for local docker-compose (8080:80 mapping).
PORT="${PORT:-80}"
export BACKEND_HOST BACKEND_PORT FRONTEND_HOST FRONTEND_PORT PORT

envsubst '${BACKEND_HOST} ${BACKEND_PORT} ${FRONTEND_HOST} ${FRONTEND_PORT} ${PORT}' \
  < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
