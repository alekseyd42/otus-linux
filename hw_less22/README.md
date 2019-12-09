## HW 22  

### Задание

настраиваем split-dns  
взять стенд https://github.com/erlong15/vagrant-bind  
добавить еще один сервер client2  
завести в зоне dns.lab  
имена  
web1 - смотрит на клиент1  
web2 смотрит на клиент2  

завести еще одну зону newdns.lab  
завести в ней запись  
www - смотрит на обоих клиентов  

настроить split-dns  
клиент1 - видит обе зоны, но в зоне dns.lab только web1  

клиент2 видит только dns.lab  

### Проверка
Модифицировал плейбуку  
Запуск:  
vagrant up  
Проверка Master:   
```Bash
host web1;host web2;host www.newdns.lab
```
Проверка Slave:  
```bash
sed -i "3d" /etc/resolv.conf 

host web1;host web2;host www.newdns.lab
```