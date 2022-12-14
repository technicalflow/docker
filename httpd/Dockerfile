#App image
FROM httpd:alpine
LABEL maintainer="Marek from mysmall.cloud"

COPY my-entrypoint.sh /
RUN apk add curl
HEALTHCHECK --interval=1m --timeout=3s CMD curl -f http://localhost/ || exit 1

WORKDIR  /usr/local/apache2/htdocs

EXPOSE 80

ENTRYPOINT ["/my-entrypoint.sh"]
RUN chown -R www-data:www-data /usr/local/apache2/htdocs && chown -R www-data:www-data /usr/local/apache2/logs/ && echo "ServerName 127.0.0.1" >> /usr/local/apache2/conf/httpd.conf

# RUN sh /docker-entrypoint.sh
#STOPSIGNAL SIGQUIT

USER www-data
CMD ["httpd-foreground"]
