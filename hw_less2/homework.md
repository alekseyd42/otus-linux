Добавил в Vagrantfile файл секции ещё для трех дисков (sata 5-7) 
сделал инициализацию raid 10 из 6ти дисков + 1 spare drive
сделал 5 разделов

[Vagrantfile](https://github.com/alekseyd42/otus-linux/blob/master/hw_less2/Vagrantfile) 

*Вывод lsblk после старта ВМ:*
[vagrant@otuslinux ~]$ lsblk                    
NAME      MAJ:MIN RM   SIZE RO TYPE   MOUNTPOINT
sda         8:0    0    40G  0 disk             
`-sda1      8:1    0    40G  0 part   /         
sdb         8:16   0   250M  0 disk             
`-md0       9:0    0   744M  0 raid10           
  |-md0p1 259:3    0   147M  0 md               
  |-md0p2 259:4    0 148.5M  0 md               
  |-md0p3 259:5    0   150M  0 md               
  |-md0p4 259:0    0 148.5M  0 md               
  `-md0p5 259:1    0   147M  0 md               
sdc         8:32   0   250M  0 disk             
`-md0       9:0    0   744M  0 raid10           
  |-md0p1 259:3    0   147M  0 md               
  |-md0p2 259:4    0 148.5M  0 md               
  |-md0p3 259:5    0   150M  0 md               
  |-md0p4 259:0    0 148.5M  0 md               
  `-md0p5 259:1    0   147M  0 md               
sdd         8:48   0   250M  0 disk             
`-md0       9:0    0   744M  0 raid10           
  |-md0p1 259:3    0   147M  0 md               
  |-md0p2 259:4    0 148.5M  0 md               
  |-md0p3 259:5    0   150M  0 md               
  |-md0p4 259:0    0 148.5M  0 md               
  `-md0p5 259:1    0   147M  0 md               
sde         8:64   0   250M  0 disk             
`-md0       9:0    0   744M  0 raid10           
  |-md0p1 259:3    0   147M  0 md               
  |-md0p2 259:4    0 148.5M  0 md               
  |-md0p3 259:5    0   150M  0 md               
  |-md0p4 259:0    0 148.5M  0 md               
  `-md0p5 259:1    0   147M  0 md               
sdf         8:80   0   250M  0 disk             
`-md0       9:0    0   744M  0 raid10           
  |-md0p1 259:3    0   147M  0 md               
  |-md0p2 259:4    0 148.5M  0 md               
  |-md0p3 259:5    0   150M  0 md               
  |-md0p4 259:0    0 148.5M  0 md               
  `-md0p5 259:1    0   147M  0 md               
sdg         8:96   0   250M  0 disk             
`-md0       9:0    0   744M  0 raid10           
  |-md0p1 259:3    0   147M  0 md               
  |-md0p2 259:4    0 148.5M  0 md               
  |-md0p3 259:5    0   150M  0 md               
  |-md0p4 259:0    0 148.5M  0 md               
  `-md0p5 259:1    0   147M  0 md               
sdh         8:112  0   250M  0 disk             
`-md0       9:0    0   744M  0 raid10           
  |-md0p1 259:3    0   147M  0 md               
  |-md0p2 259:4    0 148.5M  0 md               
  |-md0p3 259:5    0   150M  0 md               
  |-md0p4 259:0    0 148.5M  0 md               
  `-md0p5 259:1    0   147M  0 md               

*Статус рейда:*
[root@otuslinux ~]# cat /proc/mdstat                                   
Personalities : [raid10]                                               
md0 : active raid10 sdg[5] sdf[4] sde[3] sdd[2] sdb[0] sdc[1] sdh[6](S)
      761856 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU] 
                                                                       
unused devices: <none>                                                 

*Сломал рейд*
    1.пометил диск sdg как сбойный
    sudo mdadm /dev/md0 -f /dev/sdg
Увидел , что spare drive заменил его 
Every 2.0s: cat /proc/mdstat                                           
                                                                       
Personalities : [raid10]                                               
md0 : active raid10 **sdg[5](F)** sdf[4] sde[3] sdd[2] sdb[0] sdc[1] **sdh[6]**
      761856 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU] 
                                                                       
unused devices: <none>                                                 
    
    2.пометил диск sdh как сбойный
sudo mdadm /dev/md0 -f /dev/sdh
увидел, что рейд работает не полностью
Personalities : [raid10]                                                  
md0 : active raid10 **sdg[5](F)** sdf[4] sde[3] sdd[2] sdb[0] sdc[1] **sdh[6](F)**
      761856 blocks super 1.2 512K chunks 2 near-copies [6/5] **[UUUUU_]**
    
    3.Удалил диски сбойные диски

[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -r /dev/sdg 
mdadm: hot removed /dev/sdg from /dev/md0              
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -r /dev/sdh 
mdadm: hot removed /dev/sdh from /dev/md0              

Personalities : [raid10]                                               
md0 : active raid10 sdf[4] sde[3] sdd[2] sdb[0] sdc[1]                 
      761856 blocks super 1.2 512K chunks 2 near-copies [6/5] [UUUUU_] 

    4.Добавил свежие диски

[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -a /dev/sdg 
mdadm: added /dev/sdg                                  
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -a /dev/sdh 
mdadm: added /dev/sdh                                  

Рейд в нормальном состояние (Radi10 + spare)
Personalities : [raid10]                                               
md0 : active raid10 sdh[7](S) sdg[6] sdf[4] sde[3] sdd[2] sdb[0] sdc[1]
      761856 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU] 










