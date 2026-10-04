FROM rockylinux:9

RUN dnf install -y epel-release && \
    dnf install -y httpd python3-mod_wsgi python3-flask traceroute && \
    dnf clean all

RUN useradd -r -m -d /home/ipcheck -s /sbin/nologin ipcheck && \
    mkdir -vp /var/www/html/ip/icanhaz/

# Configure the WSGI application
COPY icanhaz.wsgi /var/www/html/ip/icanhaz.wsgi
COPY icanhaz-app.conf /etc/httpd/conf.d/icanhaz-app.conf
COPY icanhaz-config.stub /etc/httpd/conf.d/icanhaz-config.stub
COPY icanhaz.py /var/www/html/ip/icanhaz/icanhaz.py

RUN chown -R ipcheck:ipcheck /var/www/html/ip && \
    echo "ServerTokens Prod" > /etc/httpd/conf.d/servertokens.conf && \
    echo "ServerName localhost" > /etc/httpd/conf.d/servername.conf

# Set up a suid version of traceroute owned by root to enable icanhaztrace.com features
# RUN cp /bin/traceroute /bin/traceroute-suid
# RUN chown root:root /bin/traceroute-suid
# RUN chmod u+s /bin/traceroute-suid

EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
