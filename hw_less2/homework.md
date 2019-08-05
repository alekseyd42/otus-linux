1.Добавил в Vagrantfile файл секции ещё для трех дисков (sata 5-7) 
    [Vagrantfile](Vagrantfile) 
2.Увидел диски в системе 
[vagrant@otuslinux ~]$ lsblk              
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk           
`-sda1   8:1    0   40G  0 part /         
sdb      8:16   0  250M  0 disk           
sdc      8:32   0  250M  0 disk           
sdd      8:48   0  250M  0 disk           
sde      8:64   0  250M  0 disk           
sdf      8:80   0  250M  0 disk           
sdg      8:96   0  250M  0 disk           
sdh      8:112  0  250M  0 disk           
