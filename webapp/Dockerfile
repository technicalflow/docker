# App image
FROM nginx:stable
LABEL maintainer="Marek from mysmall.cloud"

# COPY website/index.html /usr/share/nginx/html
COPY --chmod=755 my-entrypoint.sh /my-entrypoint.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1

WORKDIR /usr/share/nginx/html

EXPOSE 80

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/my-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
