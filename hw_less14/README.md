### ДЗ 16
**Задача:**
Настроить политику бэкапа директории /etc с клиента:
1) Полный бэкап - раз в день
2) Инкрементальный - каждые 10 минут
3) Дифференциальный - каждые 30 минут  

**Решение:**  
  
https://habr.com/ru/company/flant/blog/420055/  

Вагрант файл для двух вм с именами client(192.168.11.101) & server(192.158.11.102)  
[Vagrantfile](Vagrantfile)  
В /etc/hosts добавляю(лень ДНС сервер делать)  
192.168.11.101  client  
192.168.11.102  server

запускаем ansible-playbook playbooks/borg.yml для установки и конфигурации borg  
В крон добавлено задание на копирование директории /etc сервера client раз в 5 минут.  
Для комунникации по ssh заранее подготовленны файлы с ключиками.  
Листинг:  
``` bash
[root@server borg]# borg list myrepo1                                                                                  
etc-Mon Sep 30 13:50:01 UTC 2019     Mon, 2019-09-30 13:50:02 [87ca25838eb5c80f6ddbd63285e01dc5f3a83d68bff1614715c16bd119596db4]                                                                                                              
etc-Mon Sep 30 13:55:01 UTC 2019     Mon, 2019-09-30 13:55:02 [fb24bc86df3e8327cf0d0cf2f5f7d438cb17f39fcbccec4f7dbf27c6f30a71dd]                                                                                                              
etc-Mon Sep 30 14:00:01 UTC 2019     Mon, 2019-09-30 14:00:02 [5f96925177dc9b536e11a3c27cde3fe25a24a4f52fbc1da68a5f375aa45caafc]                                                                                                              
etc-Mon Sep 30 14:05:01 UTC 2019     Mon, 2019-09-30 14:05:02 [8fef96527c82e40be9fae4811986ad2e733f83841d0f7d17385cbad419ee87d3]                                                                                                              
etc-Mon Sep 30 14:10:01 UTC 2019     Mon, 2019-09-30 14:10:03 [8d5b888f45561d1ad3586fd3a47e09b651a5e0b79ec6966311a906d1dff48c83]                                                                                                              
etc-Mon Sep 30 14:15:02 UTC 2019     Mon, 2019-09-30 14:15:03 [d21a2083e845ba1dea2247bcff36ac269ac6fcb0ddb2ad2952679bb3ef034b61]                                                                                                              
etc-Mon Sep 30 14:20:01 UTC 2019     Mon, 2019-09-30 14:20:02 [cd21902aea52cece128a48c3c77e4b60f8206f7586b0145452daab3c4cb52ff4]                                                                                                              
etc-Mon Sep 30 14:25:01 UTC 2019     Mon, 2019-09-30 14:25:02 [e3aab476404eb22764f47fa40dc6f4f3e07c8d79344f6732eff3472da9fde9bf]                                                                                                              
```
