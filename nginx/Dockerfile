FROM nginx:latest

# Install envsubst
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Copy template config
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
# Strip Windows CRLF if present (avoids "exec /entrypoint.sh: no such file or directory" in Linux containers)
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

# Metadata only; real listen port is $PORT at runtime (Railway injects this).
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
