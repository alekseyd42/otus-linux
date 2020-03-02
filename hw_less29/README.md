### MYSQL Innodb-cluster
Поднимаем Innodb cluster в докере с docker-compose и docker-swarm

vagrant UP  
Поднимается ВМ , ansible ставит docer в котором стартует docker swarm в составе четырех контейнеров:
три mssql ноды(mssql0-2)  
один mssql роутер 
На сборку кластера уходит около одной-двух минут.  
*Проверка*  
mysqlsh --uri=root@192.168.11.100:6446 -ppassword  
(dba.getCluster()).status()  

или  
Vagrant ssh  
mysqlsh --uri=root@192.168.11.100:6446 -ppassword  
(dba.getCluster()).status()  


Образы контейнеров сделаны на основе centos 8 с установденным mssql8   
[mssql-node](./dc-centos-mysql-node)  


[mssql-router](./dc-centos-mysql-router)    

[docker-compose.yml](./pr0/docker-compose.yml)  

