
### 4*. Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл

Задание необходимо сделать с использованием Vagrantfile и proviosioner shell (или ansible, на Ваше усмотрение)

Прилагаются файл [Vagrantfile](Vagrantfile)

В файле Vagrant при запуске и конфигурации ВМ выполняется скрипт [task4.sh](task4.sh), который устанавливает jiru и копирует созданные заранее jira.service и jira

config.vm.provision "shell", path: "task4.sh"

