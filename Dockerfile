FROM alpine:3.3
MAINTAINER Saïd Bouras <said.bouras@gmail.com>

ENV \
    S6_OVERLAY_VERSION=1.17.1.2

RUN set -x \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk --update upgrade

ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz /tmp/

# INSTALL NGINX and INCRON
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && apk --update add nginx incron\
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/s6-overlay-amd64.tar.gz \
    && echo "\ndaemon off;" >> /etc/nginx/nginx.conf \
    && chown -R nginx:nginx /var/log/nginx \
    && echo "root" > /etc/incron.allow \
    && echo "/etc/nginx/sites-enabled/ IN_MODIFY,IN_CREATE,IN_DELETE,IN_NO_LOOP /usr/sbin/nginx -s reload" >> /var/spool/incron/root \
    && echo "/etc/nginx/sites-available/ IN_MODIFY,IN_CREATE,IN_DELETE,IN_NO_LOOP /usr/sbin/nginx -s reload" >> /var/spool/incron/root \
    && echo "/etc/nginx/conf.d/ IN_MODIFY,IN_CREATE,IN_DELETE,IN_NO_LOOP /usr/sbin/nginx -s reload" >> /var/spool/incron/root \
    && echo "/etc/nginx/nginx.conf IN_MODIFY /usr/sbin/nginx -s reload" >> /var/spool/incron/root

# Clean
RUN find . -type d -name ".git" | xargs rm -rf

# Copy configuration file and init files
COPY ./root/ /

# Expose ports.
EXPOSE 80
EXPOSE 443

# Define mountable directories.
VOLUME ["/etc/nginx"]

# Define working directory.
WORKDIR /etc/nginx

ENTRYPOINT ["/init"]