## Домашнее задание
Роль для настройки веб сервера
Варианты стенда
nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular)
nginx + java (tomcat/jetty/netty) + go + ruby
можно свои комбинации

Реализации на выбор
- на хостовой системе через конфиги в /etc
- деплой через docker-compose

К сдаче примается
vagrant стэнд с проброшенными на локалхост портами
каждый порт на свой сайт
через нжинкс
Рекомендуем сдать до: 16.03.2020 

## Проверка
vagrant up  
Стэнд разворачивается 2-5 минут, т.к. долго ставятся laravel и ang   
В стэнде: вагрант ВМ, в ВМ docke swarm с 4мя контейнерами nginx + php-fpm(laravel)+ python(django) + js(angular)  
все контейнеры сделанны на основе Alpine:latest  
[Nginx](./nginx)  
[php-fpm](./php-fpm/)  
[django](./django/)  
[angular](./ang/)  
[docker-compose-swarm](docker_compose-swarm.yaml)  
Разворачивается всё ансиблом из вагрант файла.  
Для проверки:  
* [Nginx](http://192.168.11.100)   
* [laravel](http://192.168.11.100:8000)  
* [django](http://192.168.11.100:9000)  
* [angular](http://192.168.11.100:4000)  
