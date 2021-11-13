FROM fedora:36

RUN dnf -y install httpd mod_wsgi python-flask traceroute && dnf clean all
RUN mkdir -vp /var/www/html/ip/icanhaz/

RUN useradd icanhaz

# Set up a suid version of traceroute owned by root to enable icanhaztrace.com features
# RUN cp /bin/traceroute /bin/traceroute-suid
# RUN chown root:root /bin/traceroute-suid
# RUN chmod u+s /bin/traceroute-suid

# Configure the wsgi application
ADD icanhaz.wsgi /var/www/html/ip/icanhaz.wsgi
ADD icanhaz-app.conf /etc/httpd/conf.d/icanhaz-app.conf
ADD icanhaz-config.stub /etc/httpd/conf.d/icanhaz-config.stub
ADD icanhaz.py /var/www/html/ip/icanhaz/icanhaz.py
RUN echo "ServerTokens Prod" >> /etc/httpd/conf.d/servertokens.conf
RUN echo "ServerName icanhazip.com" >> /etc/httpd/conf.d/servername.conf

ENTRYPOINT ["/usr/sbin/httpd"]
EXPOSE 80
CMD ["-D", "FOREGROUND"]
