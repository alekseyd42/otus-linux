# Домашняя работа 10
## 1. Запретить всем пользователям, кроме группы admin логин в выходные(суббота и воскресенье), без учета праздников

В hw_less10 стартуем Vagrant

Из hw_less10/Ansible накатываем playbook

ansible-playbook Playbooks/task1.yml

Плейбука:
- создает трех пользователей (day,nignt,friday) с паролем Otus2019
- Добавляет модули PAMD для sshd
- Редактирет файл time.conf

## 2. Дать конкретному пользователю права рута

В hw_less10 стартуем Vagrant

Из hw_less10/Ansible накатываем playbook

ansible-playbook Playbooks/task2.yml

пелйбука :
- создает пользователя test с паролем Test123
- разрешает пользователю подключения по ssh
- делает sudo без запроса пароля
