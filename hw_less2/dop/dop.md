За основу взял 

https://habr.com/ru/post/248073/

lsblk после загрузки 

```bash
[root@otuslinux vagrant]# lsblk          
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0  40G  0 disk           
`-sda1   8:1    0  40G  0 part /         
sdb      8:16   0  20G  0 disk           
sdc      8:32   0  20G  0 disk           


##SELINUX Disabled

parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary xfs 0% 100%
sfdisk -d /dev/sda | sfdisk /dev/sdb
fdisk /dev/sdb
#set t -> fd
mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/sdb1
mkfs.xfs /dev/md0
mount /dev/md0 /mnt
rsync -axu / /mnt/
mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev  && mount --bind /sys /mnt/sys &&mount --bind /run /mnt/run 
chroot /mnt/
blkid
```
меняю в /etc/fstab UUID sda на UUID md0

```bash
mv /boot/initramfs.img /boot/initramfs.img.bak
dracut /boot/initramfs-$(uname -r).img $(uname -r)

«rd.auto=1» явно через «GRUB», «GRUB_CMDLINE_LINUX»:

vim /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-install /dev/sdb
reboot
```

Из вируалбокса удалил disk

```bash
parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary xfs 0% 100%
fdisk /dev/sda
mdadm --manage /dev/md0 --add /dev/sdb1
grub2-install /dev/sdb\

[root@otuslinux ~]# cat /proc/mdstat     
Personalities : [raid1]                  
md0 : active raid1 sdb1[2] sda1[1]       
      5236736 blocks super 1.2 [2/2] [UU]

vagrant@otuslinux ~]$ lsblk                  
AME    MAJ:MIN RM SIZE RO TYPE  MOUNTPOINT   
da       8:0    0   5G  0 disk               
-sda1    8:1    0   5G  0 part               
 `-md0   9:0    0   5G  0 raid1 /            
db       8:16   0   5G  0 disk               
-sdb1    8:17   0   5G  0 part               
 `-md0   9:0    0   5G  0 raid1 /            


```