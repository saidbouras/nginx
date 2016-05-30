FROM debian:jessie
MAINTAINER Saïd Bouras <said.bouras@gmail.com>

ENV \
    DEBIAN_FRONTEND=noninteractive \
    S6_OVERLAY_VERSION=1.17.1.2

RUN set -x \
    && echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list \
    && apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
    && apt-get update

ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz /tmp/

# INSTALL NGINX and INCRON
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && apt-get install -y --no-install-recommends nginx incron \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/s6-overlay-amd64.tar.gz \
    && echo "\ndaemon off;" >> /etc/nginx/nginx.conf \
    && chown -R nginx:nginx /var/log/nginx \
    && echo "root" > /etc/incron.allow \
    && echo "/etc/nginx/sites-enabled/ IN_MODIFY,IN_CREATE,IN_DELETE,IN_NO_LOOP /usr/sbin/nginx -s reload" >> /var/spool/incron/root \
    && echo "/etc/nginx/sites-available/ IN_MODIFY,IN_CREATE,IN_DELETE,IN_NO_LOOP /usr/sbin/nginx -s reload" >> /var/spool/incron/root \
    && echo "/etc/nginx/conf.d/ IN_MODIFY,IN_CREATE,IN_DELETE,IN_NO_LOOP /usr/sbin/nginx -s reload" >> /var/spool/incron/root \
    && echo "/etc/nginx/nginx.conf IN_MODIFY /usr/sbin/nginx -s reload" >> /var/spool/incron/root

# Clean
RUN apt-get autoremove -y --purge \
    && find . -type d -name ".git" | xargs rm -rf

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
