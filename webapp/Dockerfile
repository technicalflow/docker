#App image
FROM nginx:latest
LABEL maintainer="Marek from mysmall.cloud"

# COPY website/index.html /usr/share/nginx/html
COPY my-entrypoint.sh /

HEALTHCHECK --interval=1m --timeout=5s CMD curl -f http://localhost/ || exit 1

WORKDIR  /usr/share/nginx/html

EXPOSE 80
#	EXPOSE 443
ENTRYPOINT ["/my-entrypoint.sh"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
