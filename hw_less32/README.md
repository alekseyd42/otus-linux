## Домашнее задание
PostgreSQL
- Настроить hot_standby репликацию с использованием слотов
- Настроить правильное резервное копирование''

Для сдачи работы присылаем ссылку на репозиторий, в котором должны обязательно быть Vagranfile и плейбук Ansible, конфигурационные файлы postgresql.conf, pg_hba.conf и recovery.conf, а так же конфиг barman, либо скрипт резервного копирования. Команда "vagrant up" должна поднимать машины с настроенной репликацией и резервным копированием. Рекомендуется в README.md файл вложить результаты (текст или скриншоты) проверки работы репликации и резервного копирования. 

### Настроить hot_standby репликайцию  
vagrant up   -  поднимает две вм pgsql0 (192.168.11.100) и pgsql1 (192.168.11.101) c centos8.Обновляет, утстанавливает постгрес, задайт пароли (l:postgres P:postgres, l:repluser P:password) для пользователей, создаёт базу и при помощи pg_basebackup синхронизирует.  
файлы:  
[pgsql0/postgres.conf](./ansible/roles/pg/files/pgsql0/postgres.conf)    
[pgsql0/pg_hba.conf](ansible/roles/pg/files/pgsql0/pg_hba.conf)  
[pgsql1/pg_hba.conf](ansible/roles/pg/files/pgsql1/pg_hba.conf)  
конфиг recovery.conf формируется автоматически , при выполнение комманды   
```
pg_basebackup -h 192.168.11.100 -D "{{ pgpath }}data" -U repluser -v -P --write-recovery-conf -X stream -S replslot" '
```
Листинг ниже:  
```bash
[root@pgsql1 ~]# cat /var/lib/pgsql/data/recovery.conf 
standby_mode = 'on'
primary_conninfo = 'user=repluser passfile=''/var/lib/pgsql/.pgpass'' 
host=192.168.11.100 port=5432 sslmode=prefer sslcompression=0 gssencmo
de=prefer krbsrvname=postgres target_session_attrs=any'
primary_slot_name = 'replslot'

```  
проверка работы репликации:  
*pgsql0*
```
-[ RECORD 1 ]----+------------------------------
pid              | 26658
usesysid         | 16384
usename          | repluser
application_name | walreceiver
client_addr      | 192.168.11.101
client_hostname  | 
client_port      | 57350
backend_start    | 2020-05-04 15:43:13.459252+00
backend_xmin     | 
state            | streaming
sent_lsn         | 0/B000140
write_lsn        | 0/B000140
flush_lsn        | 0/B000140
replay_lsn       | 0/B000140
write_lag        | 
flush_lag        | 
replay_lag       | 
sync_priority    | 0
sync_state       | async
```
*pgsql1*
```
pid                   | 25843
status                | streaming
receive_start_lsn     | 0/B000000
receive_start_tli     | 1
received_lsn          | 0/B000140
received_tli          | 1
last_msg_send_time    | 2020-05-04 16:16:48.386816+00
last_msg_receipt_time | 2020-05-04 16:16:48.389525+00
latest_end_lsn        | 0/B000140
latest_end_time       | 2020-05-04 15:45:44.879916+00
slot_name             | replslot
conninfo              | user=repluser passfile=/var/lib/pgsql/.pgpass 
dbname=replication host=192.168.11.100 port=5432 fallback_application_
name=walreceiver sslmode=prefer sslcompression=0 gssencmode=prefer krb
srvname=postgres target_session_attrs=any

```
###Настроить правильное резервное копирование  
Выполнять резервное копирование буду с использованием barman на сервер pgbar0.
Конфиги для серверов pgsql0 и pgsql1.  
[pgbar0](ansible/roles/pg/files/pgbar0/pgsql0.conf)    
[pgsql1](ansible/roles/pg/files/pgbar0/pgsql1.conf)  