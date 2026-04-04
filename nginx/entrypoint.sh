#!/bin/bash
envsubst '${BACKEND_HOST},${BACKEND_PORT},${FRONTEND_HOST},${FRONTEND_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'
