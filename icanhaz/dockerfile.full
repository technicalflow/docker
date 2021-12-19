FROM centos:7

RUN yum update -y && yum install -y httpd mod_wsgi python-flask traceroute && yum clean all 
RUN mkdir -vp /var/www/html/ip/icanhaz/ && useradd ipcheck

# Set up a suid version of traceroute owned by root to enable icanhaztrace.com features
# RUN cp /bin/traceroute /bin/traceroute-suid
# RUN chown root:root /bin/traceroute-suid
# RUN chmod u+s /bin/traceroute-suid

# Configure the wsgi application
ADD icanhaz.wsgi /var/www/html/ip/icanhaz.wsgi
ADD icanhaz-app.conf /etc/httpd/conf.d/icanhaz-app.conf
ADD icanhaz-config.stub /etc/httpd/conf.d/icanhaz-config.stub
ADD icanhaz.py /var/www/html/ip/icanhaz/icanhaz.py
RUN echo "ServerTokens Prod" >> /etc/httpd/conf.d/servertokens.conf && echo "ServerName pinkrocket.pl" >> /etc/httpd/conf.d/servername.conf

ENTRYPOINT ["/usr/sbin/httpd"]
EXPOSE 80
CMD ["-D", "FOREGROUND"]
