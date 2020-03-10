#!/usr/bin/env sh 
if [ ! -d "/www/ang" ]
then
mkdir /www/ang
ng new ang --directory /www/ang --skip-git --routing --style css 
fi
cd /www/ang
ng serve --open --host $(hostname -i) --disable-host-check