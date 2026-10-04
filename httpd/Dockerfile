# App image
FROM httpd:2.4-alpine
LABEL org.opencontainers.image.authors="marek@techfellow.it"

RUN apk add --no-cache curl

# Configure Apache server name to avoid startup FQDN warnings
RUN echo "ServerName 127.0.0.1" >> /usr/local/apache2/conf/httpd.conf

# Copy entrypoint script and ensure execution permissions
COPY my-entrypoint.sh /usr/local/bin/my-entrypoint.sh

# Adjust permissions so non-root www-data user can write generated web files and logs
RUN chmod +x /usr/local/bin/my-entrypoint.sh; chown -R www-data:www-data /usr/local/apache2/htdocs /usr/local/apache2/logs

WORKDIR /usr/local/apache2/htdocs

EXPOSE 80

# Switch to non-root user for security best practice
USER www-data

# Healthcheck for load balancer health monitoring
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/usr/local/bin/my-entrypoint.sh"]
CMD ["httpd-foreground"]
