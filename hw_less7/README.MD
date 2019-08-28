# Домашняя работа 7
 - ### Попасть в систему без пароля несколькими способами
    - 1.

        Во время загрузки системы вызываем редактор GRUB при помощи клавиши E на нужной версии ядра
        
        Далее в строке после fi , linux16 .....
        
        находим ro , удаляем и пишем rw init=/sysroot/bin/sh и жмём x(продолжение загрузки)
        
        после этапа загрузки появиться shell в нем выыполняем команды :
        
            chroot /sysroot 
        
            passwd
        
            touch /.autorebel (чтобы selinux не ворчал)
        
        После нормально загружаемся и входим под рутом с новым паролем

    - 2 

        Смысл в том же, что и в пункте 1, только в конце строки linux16 ... дописываем rd.break

        Проверяем что sysroot доступен в запись 
        
        mount | grep sysroot

        по дефолту он недоступен, поэтому перемантируем 

        mount -o remount,rw /sysroot/
        
        mount | grep sysroot

        далее как в п.1  charoot -> passwd -> touch /.autorebel

       **  в случае с нашей вм для Vagranta надо удалить опции console для работы метода 2 **

 - ### Установить систему с LVM, после чего переименовать VG

```BASH

        [root@lvm ~]# vgdisplay 
  --- Volume group ---
  VG Name               VolGroup00
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <38.97 GiB
  PE Size               32.00 MiB
  Total PE              1247
  Alloc PE / Size       1247 / <38.97 GiB
  Free  PE / Size       0 / 0   
  VG UUID               SA8LTU-F2yz-FEV1-RdgT-hw0Z-iRxh-yHFKuU

[root@lvm VolGroup00]# vgrename VolGroup00 VG0
  Volume group "VolGroup00" successfully renamed to "VG0"
[root@lvm VolGroup00]# vgdisplay 
  --- Volume group ---
  VG Name               VG0
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <38.97 GiB
  PE Size               32.00 MiB
  Total PE              1247
  Alloc PE / Size       1247 / <38.97 GiB
  Free  PE / Size       0 / 0   
  VG UUID               SA8LTU-F2yz-FEV1-RdgT-hw0Z-iRxh-yHFKuU

#edit /etc/fstab
[root@lvm VolGroup00]# cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Sat May 12 18:50:26 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/VG0-LogVol00 /                       xfs     defaults        0 0
UUID=570897ca-e759-4c81-90cf-389da6eee4cc /boot                   xfs     defaults        0 0
/dev/mapper/VolGroup00-LogVol01 swap                    swap    defaults        0 0
vi /boot/grub2/grub.cfg
#редактируем имя старой VG на новую
 mv /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img.old
 mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
 reboot
[vagrant@lvm ~]$ lsblk
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                 8:0    0   40G  0 disk 
├─sda1              8:1    0    1M  0 part 
├─sda2              8:2    0    1G  0 part /boot
└─sda3              8:3    0   39G  0 part 
  ├─VG00-LogVol00 253:0    0 37.5G  0 lvm  /
  └─VG00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
sdb                 8:16   0   10G  0 disk 
sdc                 8:32   0    2G  0 disk 
sdd                 8:48   0    1G  0 disk 
sde                 8:64   0    1G  0 disk 


```
    После перезагрузки у меня ОС не взлетела, понадобилос из редактора груп подправить имя lsVG(ошибся 0),после перезагрузился , поправил в /etc/grub2.cfg и пересобрал initrd

 - ### Добавить модуль в initrd
  
Создал директорию /usr/lib/dracut/modules.d/01test

В нее из соседней директории скопировал module-stup.sh и отредактировал
```bash
[vagrant@lvm 01test]$ cat module-setup.sh 
#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
 return 0 
}

depends() {
    return 0
}

install() {
        inst_hook cleanup 00 "${moddir}/test.sh"
}
[vagrant@lvm 01test]$ cat test.sh 
#!/bin/sh
exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
echo '123'
echo '123'
echo '123'
echo '123'
echo '123'
echo '123'
echo '123'
echo '123'
echo '123'
sleep 60

#пересобьрал initrd
```
После перезагрузки машины, в косоле виртуальбокса получил вывод много раз 123 и ожидание в 1 мин.
