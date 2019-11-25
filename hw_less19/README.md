## Домашнее Задание
LDAP  
1. Установить FreeIPA  
2. Написать playbook для конфигурации клиента  
3*. Настроить авторизацию по ssh-ключам      

## Выполнение
 ipa.lab.lan  - сервер IPA  
 cl0.lab.lan - клиент IPA  
 pinky - тестовый пользователь   
 otuslinux - пароль на все(pinky,admin,directory manager)  
 вм с 4 ГБ рам и 4 ядра  
```BASH
 vagrant up
```
 Что делает плейбука:  
 инсталлирует сервер IPA на вм ipa.lab.lan   
 инсталлирует клиент IPA на cl0.lab.lan  
 создает пользователя pinky   
 добавляет HBAC группу, для разрешения пользователю логиниться на cl0.lab.lan  
```BASH
 ssh pinky@192.168.50.11 
```
