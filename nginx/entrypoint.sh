#!/bin/bash
set -e

echo "BACKEND_HOST=${BACKEND_HOST}"
echo "BACKEND_PORT=${BACKEND_PORT}"
echo "FRONTEND_HOST=${FRONTEND_HOST}"
echo "FRONTEND_PORT=${FRONTEND_PORT}"

export BACKEND_HOST
export BACKEND_PORT
export FRONTEND_HOST
export FRONTEND_PORT

envsubst '${BACKEND_HOST},${BACKEND_PORT},${FRONTEND_HOST},${FRONTEND_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

echo "Generated config:"
cat /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'