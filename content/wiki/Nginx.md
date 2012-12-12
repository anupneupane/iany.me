---
updated_at: <2011-12-13 13:50:34>
created_at: <2011-12-03 03:40:47>
title: Nginx
tags: web, Linux, admin
---

Simple vhost
------------

Use variable `$host` to select root directory for different host.

~~~
server {
    listen 80;
    server_name *.iany.me;
    root /path/to/vhosts/$host;
    index index.html
}
~~~

Since 0.8.25, Nginx supports named captures in
[server_name](http://wiki.nginx.org/HttpCoreModule#server_name) directive, so we
can only use subdomain in directory name:

~~~
server {
    listen 80;
    server_name ~^(?<subdomain>.+)\.iany\.me$
    root /path/to/vhosts/$subdomain;
    index index.html
}
~~~

The name capture also can be used to setup passenger based on host name:

```
server {
  server_name ~^(.*\.)?(?<app>[^.]+)\.dev$;
  root /opt/apps/$app/public;
  rails_env development;
  passenger_enabled on;
}
```

The configuration above matches all sever names that ends with ".dev", and use
the 2nd level domain name to locate application root directory. For example,
`myapp.dev` and `www.myapp.dev` both use the root `/opt/apps/myapp/public`,
thus will serve the rails/rack app `/opt/apps/myapp/`.

Remove index.html
-----------------

Nginx does internal rewrite when client visits a directory. The following code
leads to infinite redirection.

~~~
rewrite ^(.*/)index.html$ http://$host$1;
~~~

I found
[the answer](http://nginx.org/pipermail/nginx/2010-September/022483.html) in
mailing list. It works for me in Nginx 1.0.0. `try_files` is used to avoid
internal rewrite.

See the config I used for iany.me. `index` directive is removed.

~~~
server {
    listen 80;
    server_name *.iany.me;
    root /path/to/vhosts/$host;
    location / {
        try_files $uri $uri/index.html =404;
    }
    location ~ /index.html$ {
        rewrite ^(.*/)index.html$ http://$host$1 permanent;
    }
}
~~~


