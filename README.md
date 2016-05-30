# nginx
A simple simple container running nginx and incron with s6-overlay supervisor.
Incron handles filesystem events in nginx configuration and reload it when change are done.

See [s6-overlay] wiki and [inotify]  for more explanations.

## Usage
To put out the configuration of nginx, map the directory
``` /etc/nginx ``` or ``` /etc/nginx/sites-enabled ``` like that :

```sh
docker run --net host --name nginx -dt \
    -v /etc/nginx/sites-enabled:/etc/nginx/sites-enabled \
    -v /var/log/nginx:/var/log/nginx \
    -v /var/www/:/var/www \
    -p 80:80 \
    -p 443:443 \
    nginx
```

When you use this container with a wesite docker, this will
automatically works and nginx will reload when you add the nginx configuration
file for this website.

[s6-overlay]: <https://github.com/just-containers/s6-overlay/wiki>
[inotify]: <http://inotify.aiken.cz>