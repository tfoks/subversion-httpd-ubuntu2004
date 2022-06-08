FROM ubuntu:focal-20220531

LABEL maintainer="thomas.foks@capgemini.com"

ENV APACHE_CONFDIR=/etc/apache2 \
        APACHE_ENVVARS=$APACHE_CONFDIR/envvars

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
        apt-get install -q -y --no-install-recommends apache2 php libapache2-mod-php libapache2-mod-svn subversion subversion-tools enscript tar gzip sed diffutils && \
        apt-get -y clean

# and then a few more from $APACHE_CONFDIR/envvars itself
ENV APACHE_RUN_USER=www-data \
        APACHE_RUN_GROUP=www-data \
        APACHE_RUN_DIR=/var/run/apache2 \
        APACHE_PID_FILE=$APACHE_RUN_DIR/apache2.pid \
        APACHE_LOCK_DIR=/var/lock/apache2 \
        APACHE_LOG_DIR=/var/log/apache2 \
        LANG=C

# ...
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

COPY apache2/ /etc/apache2/
#COPY htdocs/ /srv/www/htdocs/

# add WebSVN to htdocs
COPY websvn-2.6.1.tar.gz /var/www/html/
RUN cd /var/www/html && tar xzf websvn-2.6.1.tar.gz && mv websvn-2.6.1 websvn && rm websvn-2.6.1.tar.gz
COPY config.php /var/www/html/websvn/include/

RUN cd /var/www/html && chown -R www-data:www-data *

EXPOSE 80 
EXPOSE 443 

ENTRYPOINT ["/usr/sbin/apache2"]

CMD ["-D", "FOREGROUND"]
