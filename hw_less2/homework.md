Добавил в Vagrantfile файл секции ещё для трех дисков (sata 5-7) 
сделал инициализацию raid 10 из 6ти дисков
сделал раздел, форматирование в ext4 и монтирование в /mnt из файла /etc/fstab

    [Vagrantfile](Vagrantfile) 
Вывод lsblk и df -h

[vagrant@otuslinux ~]$ lsblk                        
NAME   MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINT        
sda      8:0    0   40G  0 disk                     
`-sda1   8:1    0   40G  0 part   /                 
sdb      8:16   0  250M  0 disk                     
`-md0    9:0    0  744M  0 raid10 /mnt              
sdc      8:32   0  250M  0 disk                     
`-md0    9:0    0  744M  0 raid10 /mnt              
sdd      8:48   0  250M  0 disk                     
`-md0    9:0    0  744M  0 raid10 /mnt              
sde      8:64   0  250M  0 disk                     
`-md0    9:0    0  744M  0 raid10 /mnt              
sdf      8:80   0  250M  0 disk                     
`-md0    9:0    0  744M  0 raid10 /mnt              
sdg      8:96   0  250M  0 disk                     
`-md0    9:0    0  744M  0 raid10 /mnt              
sdh      8:112  0  250M  0 disk                     
[vagrant@otuslinux ~]$ df -h                        
Filesystem      Size  Used Avail Use% Mounted on    
/dev/sda1        40G  4.6G   36G  12% /             
devtmpfs        488M     0  488M   0% /dev          
tmpfs           496M     0  496M   0% /dev/shm      
tmpfs           496M  6.7M  489M   2% /run          
tmpfs           496M     0  496M   0% /sys/fs/cgroup
/dev/md0        717M  1.5M  663M   1% /mnt          
tmpfs           100M     0  100M   0% /run/user/1000




