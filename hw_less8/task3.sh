#!/usr/bin/env bash
yum install httpd -y
cp /usr/lib/systemd/system/httpd.service /etc/systemd/system/httpd@.service
sed -i 's/sysconfig\/httpd/sysconfig\/httpd-%I/' /etc/systemd/system/httpd@.service
touch /etc/sysconfig/{httpd-first,httpd-second}
echo 'OPTIONS=-f conf/first.conf' > /etc/sysconfig/httpd-first
echo 'OPTIONS=-f conf/second.conf' > /etc/sysconfig/httpd-second
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
sed -i 's/Listen 80/listen 8080/' /etc/httpd/conf/second.conf
sed -i '/listen 8080/a PidFile /var/run/httpd-second.pid' /etc/httpd/conf/second.conf
systemctl daemon-reload
systemctl start httpd@first
systemctl start httpd@second
systemctl status httpd@first httpd@second