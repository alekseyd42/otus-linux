#!/usr/bin/env bash
lspid=$(ls /proc | awk /[0-9]/|sort -n)
#Func
function gt_time () {
file='/proc/'$1'/stat'
a=$(awk '{print $14}' $file)
b=$(awk '{print $15}' $file)
c=$(awk '{print $16}' $file)
d=$(awk '{print $17}' $file)
let "milsec=(a+b+c+d)/100"
let "sec=milsec%60"
let "min=(milsec/60)%60"
let "hrs=milsec/3600"
printf '%02d:%02d\n' $min $sec
}
function gt_stat() {
        if [ -d /proc/$pid ];then 
        st=$(awk '/State/ {print $2}' /proc/$pid/status)
        stt=$(awk '{print $19}' /proc/$pid/stat)
            if [ "$stt" -lt 0 ]
            then
             stt="<"
                elif [ "$stt" -gt 0 ]    
                  then stt="N"
                elif [ "$stt" == 0 ]
                  then stt=''
            fi       
        echo $pidd' '$st$stt' '$nm
        fi
}
##Func
for pid in ${lspid[@]}
do
    if [ -d /proc/$pid/ ]; then
        #TIME
        stat=$(gt_stat $pid)
        tm=$(gt_time $pid)
        tty=$(readlink /proc/$pid/fd/0)
        read comm < /proc/$pid/cmdline
        comm=$(echo $comm|cut -c1-100)
        if [[ -z $comm ]]; then comm=$(echo "[$(awk '/Name/ {print $2}' /proc/$pid/status)]");fi
        echo $pid $tty $stat $tm $comm
    fi
done
