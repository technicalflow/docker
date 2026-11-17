FROM nginx:1.27-alpine

# http-level drop-in: UTF-8 charset + always-revalidate (daily smiley)
RUN printf '%s\n' \
    'charset utf-8;' \
    'charset_types text/html text/css application/javascript;' \
    'add_header Cache-Control "no-cache";' \
    > /etc/nginx/conf.d/extra.conf

COPY public/ /usr/share/nginx/html/

# EXPOSE 80

# HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/ >/dev/null || exit 1
