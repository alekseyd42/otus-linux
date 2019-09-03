#!/usr/bin/env bash
#копирую файлы со скриптом и файл для парсинга
cp /vagrant/{unit.sh,messages} /opt/
#копирую файлы для systemd
cp /vagrant/{mytimer.timer,mytimer.service} /etc/systemd/system/
#создаю файл с переменными для юнитфайла
echo 'STRING="cod-"' >> /etc/sysconfig/mytimer
echo 'FILE="/opt/messages"' >> /etc/sysconfig/mytimer
#настраиваю systemd
systemctl daemon-reload
systemctl enable --now mytimer.timer
#ghjdthrf
sleep 30
systemctl status mytimer.timer
systemctl status mytimer.service
sleep 5 
systemctl status mytimer.service

