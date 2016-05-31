#!/usr/bin/with-contenv /bin/sh

echo "[entrypoint.sh]  Copy configuration files"

if [ ! -d /etc/nginx/sites-available ]; then
    mkdir /etc/nginx/sites-available
    rm -rf /etc/nginx/conf.d/*
    mv /etc/nginx/default /etc/nginx/sites-available/default

    # check if there is not a previous version of default
    if [ ! -e /etc/nginx/sites-enabled/default ]; then
        rm -rf /etc/nginx/sites-enabled/default
    fi
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
fi


exit 0