#App image
FROM httpd:2.4
LABEL maintainer="marek@techfellow.it"

COPY my-entrypoint.sh /
HEALTHCHECK --interval=1m --timeout=5s CMD curl -f http://localhost/ || exit 1

WORKDIR  /usr/local/apache2/htdocs

EXPOSE 80
ENTRYPOINT ["/my-entrypoint.sh"]

RUN chown -R www-data:www-data /usr/local/apache2/htdocs && chown -R www-data:www-data /usr/local/apache2/logs/
# RUN sh /docker-entrypoint.sh
#STOPSIGNAL SIGQUIT

USER www-data
CMD ["httpd-foreground"]
