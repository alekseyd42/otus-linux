 ## Домашнее задание
OSPF
- Поднять три виртуалки
- Объединить их разными private network  
[Vagrantfile](Vagrantfile)
1. Поднять OSPF между машинами на базе Quagga  
vagrant up && ansible-playbook playbook/hw21.yml  
vagrant ssh R1  
traceroute 10.10.0.2 && ifdown eth1 && traceroute 10.10.0.2 && ifup eth1   

1. Изобразить ассиметричный роутинг  
На R1 делаем 1 линк тяжелым  
ansible-playbook playbooks/hw21_tsk2.yml  
traceroute 10.20.0.1  

2. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным  
ansible-playbook playbooks/hw21_tsk3.yml  
traceroute 10.20.0.1  


zebra 
ip route 10.20.0.0/30 10.10.0.2
ospfd 
redistribute static
