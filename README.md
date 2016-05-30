# nginx
A simple container running nginx and incron with s6-overlay supervisor.
Incron handles filesystem events to reload
nginx service automatically when changes are occured in nginx configuration files.

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

If you set up a website inside a docker container which mount the  ``` /var/www ```
directory as a shared volume, this nginx container will work in condition
that your container holding your website was started with
```  --volumes-from nginx ```.

[s6-overlay]: <https://github.com/just-containers/s6-overlay/wiki>
[inotify]: <http://inotify.aiken.cz>