FROM nginx:1.31-alpine

RUN apk add --no-cache tzdata

# Enable bundled njs module (main context, must precede "events")
RUN sed -i '1i load_module modules/ngx_http_js_module.so;' /etc/nginx/nginx.conf

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1/text >/dev/null || exit 1
