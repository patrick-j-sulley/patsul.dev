#!/bin/bash
set -e

: "${BACKEND_HOST:?BACKEND_HOST is required}"
: "${BACKEND_PORT:?BACKEND_PORT is required}"
: "${FRONTEND_HOST:?FRONTEND_HOST is required}"
: "${FRONTEND_PORT:?FRONTEND_PORT is required}"

export BACKEND_HOST BACKEND_PORT FRONTEND_HOST FRONTEND_PORT

envsubst '${BACKEND_HOST} ${BACKEND_PORT} ${FRONTEND_HOST} ${FRONTEND_PORT}' \
  < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
