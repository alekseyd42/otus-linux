#!/usr/bin/env sh 
if [ ! -d "/www/djtst" ]
then 
django-admin.py startproject djtst /www
fi
uwsgi --socket :9090 --plugin python3 --chdir /www/ --wsgi-file djtst/wsgi.py --ini /etc/uwsgi/uwsgi.ini
