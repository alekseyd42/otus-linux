# Домашняя работа 8

### 1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

Скрипт который будет запускать systemd [unit.sh](unit.sh) 

Сервис для systemd [mytimer.service](mytimer.service)

Таймер для systemd  [mytimer.timer](mytimer.timer)

лог файл для поиска  [messages](messages)

скрипт для настройки всег хозяйста в Vagrant  [Task1.sh](task1.sh)

Запускаю вм Vagrant 

под рутом запускаю скрипт task1.sh

В bash скриптах есть описание чего и как делаем.

### 2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
```BASH
[root@otuslinux ~]# systemctl cat spawn-fcgi.service               
# /etc/systemd/system/spawn-fcgi.service                           
[Unit]                                                             
Description=Spawn FastCGI scripts to be used by web servers        
After=local-fs.target network.target syslog.target remote-fs.target
[Service]                                                          
Type=simple                                                        
PIDFile=/var/run/spaw-fcgi.pid                                     
EnvironmentFile=/etc/sysconfig/spawn-fcgi                          
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS                          
KillMode=process                                                   
[Install]                                                          
WantedBy=multi-user.target                                         
[root@otuslinux ~]# systemctl status spawn-fcgi.service                                        
● spawn-fcgi.service - Spawn FastCGI scripts to be used by web servers                         
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)  
   Active: active (running) since Mon 2019-09-02 12:06:44 UTC; 19s ago                         
 Main PID: 18357 (php-cgi)                                                                     
   CGroup: /system.slice/spawn-fcgi.service                                                    
           ├─18357 /usr/bin/php-cgi                                                            
           ├─18358 /usr/bin/php-cgi                                                            
           ├─18359 /usr/bin/php-cgi                                                            
           ├─18360 /usr/bin/php-cgi                                                            
           ├─18361 /usr/bin/php-cgi                                                            
           ├─18362 /usr/bin/php-cgi                                                            
           ├─18363 /usr/bin/php-cgi                                                            
           ├─18364 /usr/bin/php-cgi                                                            
           ├─18365 /usr/bin/php-cgi                                                            
           ├─18366 /usr/bin/php-cgi                                                            
           ├─18367 /usr/bin/php-cgi                                                            
           ├─18368 /usr/bin/php-cgi                                                            
           ├─18369 /usr/bin/php-cgi                                                            
           ├─18370 /usr/bin/php-cgi                                                            
           ├─18371 /usr/bin/php-cgi                                                            
           ├─18372 /usr/bin/php-cgi                                                            
           ├─18373 /usr/bin/php-cgi                                                            
           ├─18374 /usr/bin/php-cgi                                                            
           ├─18375 /usr/bin/php-cgi                                                            
           ├─18376 /usr/bin/php-cgi                                                            
           ├─18377 /usr/bin/php-cgi                                                            
           ├─18378 /usr/bin/php-cgi                                                            
           ├─18379 /usr/bin/php-cgi                                                            
           ├─18380 /usr/bin/php-cgi                                                            
           ├─18381 /usr/bin/php-cgi                                                            
           ├─18382 /usr/bin/php-cgi                                                            
           ├─18383 /usr/bin/php-cgi                                                            
           ├─18384 /usr/bin/php-cgi                                                            
           ├─18385 /usr/bin/php-cgi                                                            
           ├─18386 /usr/bin/php-cgi                                                            
           ├─18387 /usr/bin/php-cgi                                                            
           ├─18388 /usr/bin/php-cgi                                                            
           └─18389 /usr/bin/php-cgi                                                            
                                                                                               
Sep 02 12:06:44 otuslinux systemd[1]: Started Spawn FastCGI scripts to be used by web servers. 
[root@otuslinux ~]# systemctl stop spawn-fcgi.service && systemctl status spawn-fcgi.service              
● spawn-fcgi.service - Spawn FastCGI scripts to be used by web servers                                    
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)             
   Active: inactive (dead)                                                                                
                                                                                                          
Sep 02 11:55:15 otuslinux systemd[1]: Started Spawn FastCGI scripts to be used by web servers.            
Sep 02 11:55:57 otuslinux systemd[1]: spawn-fcgi.service: main process exited, code=killed, status=9/KILL 
Sep 02 11:55:57 otuslinux systemd[1]: Unit spawn-fcgi.service entered failed state.                       
Sep 02 11:55:57 otuslinux systemd[1]: spawn-fcgi.service failed.                                          
Sep 02 12:05:10 otuslinux systemd[1]: Started Spawn FastCGI scripts to be used by web servers.            
Sep 02 12:05:23 otuslinux systemd[1]: Stopping Spawn FastCGI scripts to be used by web servers...         
Sep 02 12:05:23 otuslinux systemd[1]: Stopped Spawn FastCGI scripts to be used by web servers.            
Sep 02 12:06:44 otuslinux systemd[1]: Started Spawn FastCGI scripts to be used by web servers.            
Sep 02 12:07:44 otuslinux systemd[1]: Stopping Spawn FastCGI scripts to be used by web servers...         
Sep 02 12:07:44 otuslinux systemd[1]: Stopped Spawn FastCGI scripts to be used by web servers.            

```


### 3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами

Запускаем ВМ
из /vagrant/ из под рута выполняем task3.sh
[task3.sh](task3.sh)

