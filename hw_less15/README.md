### Домашняя работа 15

Докер образ: docker.io/alexd42/hw_less15 

[dockerfile](dockerfile)  
docker run -d -p 80:80 alexd42/hw_less15

```bash
[root@linmore hw_less15]# curl localhost
hello from my container

```
#### Определите разницу между контейнером и образом  

Образ основа, с уже сделанными слоями, которые доступны только для чтения.  
Контейнер это образ к которому дбавляется доп слой для записи.

Ответьте на вопрос: Можно ли в контейнере собрать ядро?  
В контейнере нельзя собрать ядро, т.к. используется ядро хост системы.

### centos 8 + nginx _ php-fpm
два контейнер:  
    - nginx [alexd42/nginx0](https://cloud.docker.com/u/alexd42/repository/docker/alexd42/nginx0)  
    - php [alexd42/php-fpm0](https://cloud.docker.com/u/alexd42/repository/docker/alexd42/php-fpm0)  
yaml файл для [docker-compose](docker-compose.yml)  
Взаимодействие контейнеров через подключение папочки [site](site/) в которой два файлика index.html, index.php  
Сетевое взаимодействие через link  
Для проверки раьоты php:  
http://localhost/index.php  





