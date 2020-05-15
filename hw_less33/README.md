### Домашнее задание
Разворачиваем кластер Patroni
Цель: - Развернуть кластер PostgreSQL из трех нод. Создать тестовую базу - проверить статус репликации - Сделать switchover/failover - Поменять конфигурацию PostgreSQL + с параметром требующим перезагрузки - Настроить клиентские подключения через HAProxy 
### Проверка.
cd ansible
vagrant up && ansible-playbook provision.yml

развернул кластер на centos 8  
postgresql:pgsql0,pgsql1,pgsql1  
key stoage: consul  
balancer: haproxy  

Подключаемся к одной из нод кластера:  
PATH=$PATH:/usr/local/bin  
export PATRONI_CONSUL_HOST=192.168.11.102:8500  
patronictl list patroni  
```
+ Cluster: patroni (6826971352198791131) ----+----+-----------+
| Member |      Host      |  Role  |  State  | TL | Lag in MB |
+--------+----------------+--------+---------+----+-----------+
| pgsql0 | 192.168.11.100 | Leader | running |  1 |           |
| pgsql1 | 192.168.11.101 |        | running |  1 |         0 |
| pgsql2 | 192.168.11.104 |        | running |  1 |         0 |
+--------+----------------+--------+---------+----+-----------+
```  
Создадим базу, наполним ее и проверим , что база среплицировалась.  
psql -h192.168.11.103 -p5000 -Upostgres -c 'create database test;'  
pgbench -h192.168.11.103 -p5000 -Upostgres -i -s 10 test  
Подключимся на реплику и посмотрим наличие базы:  
psql -h192.168.11.101 -Upostgres -c 'create database test2;'
```
ERROR:  cannot execute CREATE DATABASE in a read-only transaction  
```
psql -h192.168.11.101 -Upostgres -c '\l'
```
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 test      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
(4 rows)
```  
psql -h192.168.11.104 -Upostgres -c 'create database test2;'
```
ERROR:  cannot execute CREATE DATABASE in a read-only transaction  
psql -h192.168.11.104 -Upostgres -c '\l'  
```  
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 test      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
(4 rows)
```  
Выключим postgres на ноде psql0 и проверим состояние кластера  
```BASH
systemctl stop patroni.service   
patronictl list patroni  
+ Cluster: patroni (6826971352198791131) ----+----+-----------+
| Member |      Host      |  Role  |  State  | TL | Lag in MB |
+--------+----------------+--------+---------+----+-----------+
| pgsql1 | 192.168.11.101 | Leader | running |  2 |           |
| pgsql2 | 192.168.11.104 |        | running |  2 |         0 |
+--------+----------------+--------+---------+----+-----------+
```
Вернем ноду в кластер и посмотрим состояние кластера  
```BASH
systemctl start patroni.service  
patronictl list patroni  
+ Cluster: patroni (6826971352198791131) ----+----+-----------+
| Member |      Host      |  Role  |  State  | TL | Lag in MB |
+--------+----------------+--------+---------+----+-----------+
| pgsql0 | 192.168.11.100 |        | running |  1 |         0 |
| pgsql1 | 192.168.11.101 | Leader | running |  2 |           |
| pgsql2 | 192.168.11.104 |        | running |  2 |         0 |
+--------+----------------+--------+---------+----+-----------+
```
Вернем активную ноду psql0  
```BASH
patronictl switchover --candidate pgsql0 patroni 
Master [pgsql1]: 
When should the switchover take place (e.g. 2020-05-15T09:37 )  [now]: 
Current cluster topology
+ Cluster: patroni (6826971352198791131) ----+----+-----------+
| Member |      Host      |  Role  |  State  | TL | Lag in MB |
+--------+----------------+--------+---------+----+-----------+
| pgsql0 | 192.168.11.100 |        | running |  2 |         0 |
| pgsql1 | 192.168.11.101 | Leader | running |  2 |           |
| pgsql2 | 192.168.11.104 |        | running |  2 |         0 |
+--------+----------------+--------+---------+----+-----------+
Are you sure you want to switchover cluster patroni, demoting current master pgsql1? [y/N]: y
2020-05-15 08:37:25.57433 Successfully switched over to "pgsql0"
+ Cluster: patroni (6826971352198791131) ----+----+-----------+
| Member |      Host      |  Role  |  State  | TL | Lag in MB |
+--------+----------------+--------+---------+----+-----------+
| pgsql0 | 192.168.11.100 | Leader | running |  2 |           |
| pgsql1 | 192.168.11.101 |        | stopped |    |   unknown |
| pgsql2 | 192.168.11.104 |        | running |  2 |         0 |
+--------+----------------+--------+---------+----+-----------+

patronictl list patroni
+ Cluster: patroni (6826971352198791131) ----+----+-----------+
| Member |      Host      |  Role  |  State  | TL | Lag in MB |
+--------+----------------+--------+---------+----+-----------+
| pgsql0 | 192.168.11.100 | Leader | running |  3 |           |
| pgsql1 | 192.168.11.101 |        | running |  3 |         0 |
| pgsql2 | 192.168.11.104 |        | running |  3 |         0 |
+--------+----------------+--------+---------+----+-----------+

```
Меняем опции:  
```BASH
patronictl edit-config patroni
--- 
+++ 
@@ -3,11 +3,11 @@
 postgresql:
   parameters:
     archive_mode: 'on'
-    max_connections: 100
+    max_connections: 200
     max_parallel_workers: 8
     max_wal_senders: 5
-    max_wal_size: 2GB
+    max_wal_size: 4GB
-    min_wal_size: 1GB
+    min_wal_size: 2GB
   use_pg_rewind: true
 retry_timeout: 10
 ttl: 30

Apply these changes? [y/N]: y
Configuration changed
```

