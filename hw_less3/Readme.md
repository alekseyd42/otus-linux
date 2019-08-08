# Домашняя работа
- уменьшить том под / до 8G 
       
```bash
      yum install xfsdump -y
      xfsdump /dev/VolGroup00/LogVol00 -f /home/dump
      vgextend VolGroup00 /dev/sdb
      lvcreate -L 8G -n LogVol02 VolGroup00
      mkfs.xfs /dev/VolGroup00/LogVol02
      mount /dev/VolGroup00/LogVol02 /mnt
      xfsrestore -f /home/dump /mnt/
      mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev  && mount --bind /sys /mnt/sys &&mount --bind /run /mnt/run 
      mount --bind /boot /mnt/boot/
      chroot /mnt
      vi /etc/fstab
      #меняю /dev/mapper/VolGroup00-LogVol00 на /dev/mapper/VolGroup00-LogVol02
      vi /etc/default/grub
      #меняю rd.lvm.lv=VolGroup00/LogVol00 на rd.lvm.lv=VolGroup00/LogVol02
      mv /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img.old
      dracut /boot/initramfs-$(uname -r).img $(uname -r)
      grub2-mkconfig -o /boot/grub2/grub.cfg
      [vagrant@lvm ~]$ lsblk                                     
            NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
            sda                       8:0    0   40G  0 disk           
            ├─sda1                    8:1    0    1M  0 part           
            ├─sda2                    8:2    0    1G  0 part /boot     
            └─sda3                    8:3    0   39G  0 part           
            ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]    
            └─VolGroup00-LogVol00 253:2    0 37.5G  0 lvm            
            sdb                       8:16   0   10G  0 disk           
            └─VolGroup00-LogVol02   253:0    0    8G  0 lvm  /         
            sdc                       8:32   0    2G  0 disk           
            sdd                       8:48   0    1G  0 disk           
            sde                       8:64   0    1G  0 disk           

      lvremove VolGroup00 LogVol00
      lvcreate -L 8G -n LogVol00 VolGroup00 /dev/sda3
      mkfs.xfs /dev/VolGroup00/LogVol00
      mount /dev/VolGroup00/LogVol00 /mnt 
      xfsdump /dev/VolGroup00/LogVol00 -f /home/dump
      xfsrestore -f /home/dump /mnt/
      mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev  && mount --bind /sys /mnt/sys &&mount --bind /run /mnt/run 
      mount --bind /boot /mnt/boot/
      chroot /mnt
      vi /etc/fstab
      #меняю /dev/mapper/VolGroup00-LogVol02 на /dev/mapper/VolGroup00-LogVol00
      vi /etc/default/grub
      #меняю rd.lvm.lv=VolGroup00/LogVol02 на rd.lvm.lv=VolGroup00/LogVol00
      mv /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img.old
      dracut /boot/initramfs-$(uname -r).img $(uname -r)
      grub2-mkconfig -o /boot/grub2/grub.cfg
      [vagrant@lvm ~]$ lsblk                                     
      NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      sda                       8:0    0   40G  0 disk           
      ├─sda1                    8:1    0    1M  0 part           
      ├─sda2                    8:2    0    1G  0 part /boot     
      └─sda3                    8:3    0   39G  0 part           
      ├─VolGroup00-LogVol00 253:0    0    8G  0 lvm  /         
      └─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]    
      sdb                       8:16   0   10G  0 disk           
      └─VolGroup00-LogVol02   253:2    0    8G  0 lvm            
      sdc                       8:32   0    2G  0 disk           
      sdd                       8:48   0    1G  0 disk           
      sde                       8:64   0    1G  0 disk           
```

- выделить том под /home

```bash
      #SELINUX DISABLED
      lvremove /dev/VolGroup00/LogVol02                             
      lvcreate -L 10G -n LogVol02 VolGroup00                        
      mkfs.ext4 /dev/VolGroup00/LogVol02                            
      mount /dev/mapper/VolGroup00-LogVol02 /mnt                    
      rsync -axu /home/ /mnt/                                       
      umount /mnt                                                   
      vi /etc/fstab                                                 
      [root@lvm ~]# lsblk                                        
      NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      sda                       8:0    0   40G  0 disk           
      ├─sda1                    8:1    0    1M  0 part           
      ├─sda2                    8:2    0    1G  0 part /boot     
      └─sda3                    8:3    0   39G  0 part           
      ├─VolGroup00-LogVol00 253:0    0    8G  0 lvm  /         
      ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]    
      └─VolGroup00-LogVol02 253:2    0   10G  0 lvm  /home     
      sdb                       8:16   0   10G  0 disk           
      sdc                       8:32   0    2G  0 disk           
      sdd                       8:48   0    1G  0 disk           
      sde                       8:64   0    1G  0 disk           
```

- /var - сделать в mirror

```bash
      pvcreate /dev/sdd                    
      pvcreate /dev/sde
      vgcreate VG_Mir0 /dev/sdd /dev/sde                    
      pvs                                  
      PV         VG         Fmt  Attr PSize    PFree    
      /dev/sda3  VolGroup00 lvm2 a--   <38.97g  <19.47g 
      /dev/sdb   VolGroup00 lvm2 a--    <9.97g   <9.97g 
      /dev/sdd   VG_Mir0    lvm2 a--  1020.00m 1020.00m 
      /dev/sde   VG_Mir0    lvm2 a--  1020.00m 1020.00m 
      lvcreate -l+100%FREE -m1 -n Mir0 VG_Mir0
      [root@lvm /]# lvs                                                                            
      LV       VG         Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
      Mir0     VG_Mir0    rwi-a-r--- 1016.00m                                    100.00          
      LogVol00 VolGroup00 -wi-ao----    8.00g                                                    
      LogVol01 VolGroup00 -wi-ao----    1.50g                                                    
      LogVol02 VolGroup00 -wi-ao----   10.00g                                                    
      [root@lvm /]# mkfs.ext3 /dev/mapper/VG_Mir0-Mir0
      [root@lvm /]# mount /dev/mapper/VG_Mir0-Mir0 /mnt 
      [root@lvm /]# rsync -axu /var/ /mnt/                                               
      [root@lvm /]# umount /mnt                                                          
      [root@lvm /]# echo '/dev/mapper/VG_Mir0-Mir0 /var ext3 defaults 0 0' >> /etc/fstab 
      [root@lvm /]# mount -va                                                            
      /                        : ignored                                                 
      /boot                    : already mounted                                         
      swap                     : ignored                                                 
      /home                    : already mounted                                         
      /var                     : successfully mounted                                    
      [root@lvm /]# lsblk                                                                
      NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT                        
      sda                       8:0    0   40G  0 disk                                   
      ├─sda1                    8:1    0    1M  0 part                                   
      ├─sda2                    8:2    0    1G  0 part /boot                             
      └─sda3                    8:3    0   39G  0 part                                   
      ├─VolGroup00-LogVol00 253:0    0    8G  0 lvm  /                                 
      ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]                            
      └─VolGroup00-LogVol02 253:2    0   10G  0 lvm  /home                             
      sdb                       8:16   0   10G  0 disk                                   
      sdc                       8:32   0    2G  0 disk                                   
      sdd                       8:48   0    1G  0 disk                                   
      ├─VG_Mir0-Mir0_rmeta_0  253:3    0    4M  0 lvm                                    
      │ └─VG_Mir0-Mir0        253:7    0 1016M  0 lvm  /var                              
      └─VG_Mir0-Mir0_rimage_0 253:4    0 1016M  0 lvm                                    
      └─VG_Mir0-Mir0        253:7    0 1016M  0 lvm  /var                              
      sde                       8:64   0    1G  0 disk                                   
      ├─VG_Mir0-Mir0_rmeta_1  253:5    0    4M  0 lvm                                    
      │ └─VG_Mir0-Mir0        253:7    0 1016M  0 lvm  /var                              
      └─VG_Mir0-Mir0_rimage_1 253:6    0 1016M  0 lvm                                    
      └─VG_Mir0-Mir0        253:7    0 1016M  0 lvm  /var                              
      [root@lvm /]# ls /va                                                               
      ls: cannot access /va: No such file or directory                                   
      [root@lvm /]# ls /var                                                              
      adm    db     games   kerberos  local  log         mail  opt       run    tmp      
      cache  empty  gopher  lib       lock   lost+found  nis   preserve  spool  yp       
      [root@lvm /]#reboot                                                                      
```

- /home - сделать том для снэпшотов
  - снапшоты
  - сгенерить файлы в /home/
  - снять снэпшот
  - удалить часть файлов
  - восстановится со снэпшота
  
```bash
      root@lvm /]# cd /home                  
      root@lvm home]# touch file1            
      root@lvm home]# touch file2            
      root@lvm home]# touch file3            
      root@lvm home]# ls                     
      file1  file2  file3  lost+found  vagrant
      [root@lvm ~]# lvcreate -l+20%FREE -s -n snap0 /dev/mapper/VolGroup00-LogVol02
      Logical volume "snap0" created.                                            
      [root@lvm ~]# rm -rf /home/file*|ls /home
      lost+found  vagrant                      
      umount /home      
      lvconvert --merge /dev/VolGroup00/snap0 
      mount /home                            
      [root@lvm ~]# ls /home                  
      file1  file2  file3  lost+found  vagrant
```

- прописать монтирование в fstab
   попробовать с разными опциями и разными файловыми системами ( на выбор)

```bash
      [root@lvm ~]# cat /etc/fstab                                                                  
                                                                                                   
      #                                                                                             
      # /etc/fstab                                                                                  
      # Created by anaconda on Sat May 12 18:50:26 2018                                             
      #                                                                                             
      # Accessible filesystems, by reference, are maintained under '/dev/disk'                      
      # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info                   
      #                                                                                             
      /dev/mapper/VolGroup00-LogVol00 /                       xfs     defaults        0 0           
      UUID=570897ca-e759-4c81-90cf-389da6eee4cc /boot                   xfs     defaults        0 0 
      /dev/mapper/VolGroup00-LogVol01 swap                    swap    defaults        0 0           
      /dev/mapper/VolGroup00-LogVol02 /home   ext4    noatime,nodiratime      0 0                   
      /dev/mapper/VG_Mir0-Mir0 /var ext3 defaults 0 0                                                                                                 
```
  
- *на нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снэпшотами - разметить здесь каталог /opt

   - установка
      инфу взял отсюда:

      https://github.com/zfsonlinux/zfs/wiki/RHEL-and-CentOS

      https://habr.com/ru/post/268807/

      https://www.freebsd.org/cgi/man.cgi?query=zfs&manpath=FreeBSD+8.4-RELEASE
      
      https://docs.oracle.com/cd/E19253-01/820-0836/index.html

   ```bash
      yum update -y                                                                
      reboot                                                                       
      cat /etc/redhat-release                                                      
      yum install http://download.zfsonlinux.org/epel/zfs-release.el7_6.noarch.rpm 
      yum install epel-release.noarch -y                                           
      gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux       
      yum install kernel-devel zfs                                                 
      reboot                                                                       
      [root@lvm ~]# lsmod |grep zfs                           
      zfs                  3564425  3                         
      zunicode              331170  1 zfs                     
      zavl                   15236  1 zfs                     
      icp                   270148  1 zfs                     
      zcommon                73440  1 zfs                     
      znvpair                89131  2 zfs,zcommon             
      spl                   102412  4 icp,zfs,zcommon,znvpair 
   ```

   - создание простого пула(зеркало)
   ```bash
      [root@lvm ~]# lsblk                                        
      NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      sda                       8:0    0   40G  0 disk           
      ├─sda1                    8:1    0    1M  0 part           
      ├─sda2                    8:2    0    1G  0 part /boot     
      └─sda3                    8:3    0   39G  0 part           
      ├─VolGroup00-LogVol00 253:0    0 37.5G  0 lvm  /         
      └─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]    
      sdb                       8:16   0   10G  0 disk           
      sdc                       8:32   0    2G  0 disk           
      sdd                       8:48   0    1G  0 disk           
      sde                       8:64   0    1G  0 disk           

      [root@lvm ~]# zpool create OPT_VOL mirror /dev/sdd /dev/sde
      [root@lvm ~]# zpool status OPT_VOL             
      pool: OPT_VOL                                
      state: ONLINE                                 
      scan: none requested                         
      config:                                        
                                                   
            NAME        STATE     READ WRITE CKSUM 
            OPT_VOL     ONLINE       0     0     0 
               mirror-0  ONLINE       0     0     0 
                  sdd     ONLINE       0     0     0 
                  sde     ONLINE       0     0     0 
      errors: No known data errors 

      root@lvm ~]# zpool destroy OPT_VOL

   ```
   - создание пула (зеркало) с кэшем
      ```bash
      [root@lvm ~]# zpool create OPT_VOL mirror /dev/sdd /dev/sde 
      [root@lvm ~]# lsblk                                         
      NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT 
      sda                       8:0    0   40G  0 disk            
      ├─sda1                    8:1    0    1M  0 part            
      ├─sda2                    8:2    0    1G  0 part /boot      
      └─sda3                    8:3    0   39G  0 part            
      ├─VolGroup00-LogVol00 253:0    0 37.5G  0 lvm  /          
      └─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]     
      sdb                       8:16   0   10G  0 disk            
      sdc                       8:32   0    2G  0 disk            
      sdd                       8:48   0    1G  0 disk            
      ├─sdd1                    8:49   0 1014M  0 part            
      └─sdd9                    8:57   0    8M  0 part            
      sde                       8:64   0    1G  0 disk            
      ├─sde1                    8:65   0 1014M  0 part            
      └─sde9                    8:73   0    8M  0 part            
      [root@lvm ~]# zpool add OPT_VOL cache /dev/sdc              
      [root@lvm ~]# zpool status                                  
      pool: OPT_VOL                                             
      state: ONLINE                                              
      scan: none requested                                      
      config:                                                     
                                                                  
            NAME        STATE     READ WRITE CKSUM              
            OPT_VOL     ONLINE       0     0     0              
               mirror-0  ONLINE       0     0     0              
                  sdd     ONLINE       0     0     0              
                  sde     ONLINE       0     0     0              
            cache                                               
               sdc       ONLINE       0     0     0              
                                                                  
      errors: No known data errors                                

      ```
   - монтирование пула в опт, работа со снапшотами 
      ```bash
      zpool create OPT_VOL mirror /dev/sdd /dev/sde cache /dev/sdc
      zfs set mountpoint=/opt OPT_VOL 
      zfs mount OPT_VOL
      [root@lvm ~]# zfs snapshot -r OPT_VOL@testsn
      [root@lvm ~]# zfs list -t snap                 
      NAME             USED  AVAIL  REFER  MOUNTPOINT
      OPT_VOL@testsn     0B      -  25.5K  -         
      [root@lvm ~]# ls /opt          
      test1                          
      [root@lvm ~]# rm -rf /opt/test1        
      [root@lvm ~]# ls /opt -a       
      .  ..                          
      [root@lvm ~]# zfs rollback OPT_VOL@testsn
      [root@lvm ~]# ls /opt                    
      test1                                    
      ```
