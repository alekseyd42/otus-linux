## Сборка пакетов

### создаю свой rpm пакет nginx 
Подготовка
development tools


Собираю nginx последней версии (делал из под рута, понимаю, что в проде надо создать бесправного пользователя)

скачал src.rpm отсюда
http://nginx.org/packages/rhel/8/SRPMS/

сделал [root@cod-repo0 ~]# rpm -ihv nginx-1.16.1-1.el8.ngx.src.rpm

доставил зависимости [root@cod-repo0 ~]# yum-builddep nginx

изменил SPEC в rpmbuild/SPEC/nginx.spec

в %build добавил 

--with-http_v2_module 

--with-http_ssl_module

собираю пакет с изменёным SPEC файлом rpmbuild -bb rpmbuild/SPECS/nginx.spec

на выходе получил 
```bash
[root@cod-repo0 x86_64]# pwd && ls -la                                                 
/root/rpmbuild/RPMS/x86_64                                                             
total 2512                                                                             
drwxr-xr-x 2 root root      98 авг 26 06:21 .                                          
drwxr-xr-x 3 root root      20 авг 26 06:21 ..                                         
-rw-r--r-- 1 root root  783756 авг 26 06:21 nginx-1.16.1-1.el7.ngx.x86_64.rpm          
-rw-r--r-- 1 root root 1782188 авг 26 06:21 nginx-debuginfo-1.16.1-1.el7.ngx.x86_64.rpm
```
Устаовил:

yum install ./nginx-1.16.1-1.el7.ngx.x86_64.rpm

запустил и проверил

```BASH
[root@cod-repo0 x86_64]# systemctl enable nginx && systemctl start nginx                                               │
Created symlink from /etc/systemd/system/multi-user.target.wants/nginx.service to /usr/lib/systemd/system/nginx.service│
.                                                                                                                      │

[root@cod-repo0 x86_64]# curl -l localhost                                    
<!DOCTYPE html>                                                               
<html>                                                                        
<head>                                                                        
<title>Welcome to nginx!</title>                                              
<style>                                                                       
    body {                                                                    
        width: 35em;                                                          
        margin: 0 auto;                                                       
        font-family: Tahoma, Verdana, Arial, sans-serif;                      
    }                                                                         
</style>                                                                      
</head>                                                                       
<body>                                                                        
<h1>Welcome to nginx!</h1>                                                    
<p>If you see this page, the nginx web server is successfully installed and   
working. Further configuration is required.</p>                               
                                                                              
<p>For online documentation and support please refer to                       
<a href="http://nginx.org/">nginx.org</a>.<br/>                               
Commercial support is available at                                            
<a href="http://nginx.com/">nginx.com</a>.</p>                                
                                                                              
<p><em>Thank you for using nginx.</em></p>                                    
</body>                                                                       
</html>                                                                       
```

### делаю свой репо
```bash
yum install createrepo
createrepo .
mkdir /home/repo && cd /home/repo
[root@cod-repo0 repo]# pwd && ls
/home/repo                      
repodata                        
cp /root/rpmbuild/RPMS/x86_64/nginx-1.16.1-1.el7.ngx.x86_64.rpm /home/repo/repodata/
[root@cod-repo0 repo]# createrepo .
Spawning worker 0 with 1 pkgs      
Spawning worker 1 with 1 pkgs      
Workers Finished                   
Saving Primary metadata            
Saving file lists metadata         
Saving other metadata              
Generating sqlite DBs              
Sqlite DBs complete                
```

Преверяю

в вагранте создаю в /etc/yum.repos.d hw.repo
[hw.repo](hw.repo)
```bash
[hwrepo]
name=HW-REPO
baseurl=http://86.62.114.220
enable=1
gpgcheck=0
```
Устанавливаю nginx из repo

```bash
yum install nginx
[root@otuslinux yum.repos.d]# yum install nginx                                                                                                                                                                                               
Failed to set locale, defaulting to C                                                                                                                                                                                                         
Loaded plugins: fastestmirror                                                                                                                                                                                                                 
Loading mirror speeds from cached hostfile                                                                                                                                                                                                    
 * base: mirror.logol.ru                                                                                                                                                                                                                      
 * extras: mirror.sale-dedic.com                                                                                                                                                                                                              
 * updates: mirror.logol.ru                                                                                                                                                                                                                   
base                                                                                                                                                                                                                   | 3.6 kB  00:00:00     
extras                                                                                                                                                                                                                 | 3.4 kB  00:00:00     
hwrepo                                                                                                                                                                                                                 | 2.9 kB  00:00:00     
updates                                                                                                                                                                                                                | 3.4 kB  00:00:00     
hwrepo/primary_db                                                                                                                                                                                                      | 2.8 kB  00:00:00     
Resolving Dependencies
--> Running transaction check
---> Package nginx.x86_64 1:1.16.1-1.el7.ngx will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==============================================================================================================================================================================================================================================
 Package                                               Arch                                                   Version                                                            Repository                                              Size
==============================================================================================================================================================================================================================================
Installing:
 nginx                                                 x86_64                                                 1:1.16.1-1.el7.ngx                                                 hwrepo                                                 765 k

Transaction Summary
==============================================================================================================================================================================================================================================
Install  1 Package

Total download size: 765 k
Installed size: 2.7 M
Is this ok [y/d/N]: y

systemctl start nginx
[root@otuslinux yum.repos.d]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2019-08-26 11:28:28 UTC; 1min 29s ago
     Docs: http://nginx.org/en/docs/
  Process: 6334 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 6335 (nginx)
   CGroup: /system.slice/nginx.service
           ├─6335 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           └─6336 nginx: worker process

Aug 26 11:28:28 otuslinux systemd[1]: Starting nginx - high performance web server...
Aug 26 11:28:28 otuslinux systemd[1]: PID file /var/run/nginx.pid not readable (yet?) after start.
Aug 26 11:28:28 otuslinux systemd[1]: Started nginx - high performance web server.

[root@otuslinux yum.repos.d]# nginx -V
nginx version: nginx/1.16.1
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) 
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=
/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=
/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with
-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --wi
th-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wa
ll -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'

[root@otuslinux yum.repos.d]# curl -l localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Контейнер

Контейнер alexd42/hw_less6

В контейнер установил сделанный выше nginx 1.16
