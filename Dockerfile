FROM ubuntu:focal

LABEL maintainer="thomas.foks@capgemini.com"

ENV DEBIAN_FRONTEND=noninteractive

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

RUN apt-get update && \
        apt-get install -q -y --no-install-recommends apache2 php libapache2-mod-php libapache2-mod-svn subversion subversion-tools enscript tar gzip sed diffutils && \
        apt-get -y clean

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
# and then a few more from $APACHE_CONFDIR/envvars itself
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

# ...
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

COPY apache2/ /etc/apache2/
#COPY htdocs/ /srv/www/htdocs/

EXPOSE 80 
EXPOSE 443 

ENTRYPOINT ["/usr/sbin/apache2"]

CMD ["-D", "FOREGROUND"]
