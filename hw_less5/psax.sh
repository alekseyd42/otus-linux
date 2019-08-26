#!/usr/bin/env bash
lspid=$(ls /proc | awk /[0-9]/|sort -n)
#Func
##function gt_tty {
##    for pid in ${lspid[@]}
##    do
##    sudo readlink /proc/$pid/fd/0
##    done
##
##}
function gt_time () {
file='/proc/'$1'/stat'
a=$(awk '{print $14}' $file)
b=$(awk '{print $15}' $file)
c=$(awk '{print $16}' $file)
d=$(awk '{print $17}' $file)
let "sumtime=(a+b+c+d)/100"        
let "sec=sumtime%60"               
let "min=sumtime/60%60"            
let "hrs=sumtime/3600"            
printf -v rez '%02d:%02d' $min $sec
echo $rez                          
}
##Func
for pid in ${lspid[@]}
do
    if [ -d /proc/$pid/ ]; then
        #TIME
        tm=$(gt_time $pid)
        read comm < /proc/$pid/cmdline
        if [[ -z $comm ]]; then comm=$(echo "[$(awk '/Name/ {print $2}' /proc/$pid/status)]");fi
        printf '%s %s %s\n' "$pid" "$tm" "$comm"
    fi
done


#tty=$(gt_tty)
#printf "  PID TTY COMMAND "'\n'
#printf "${lspid[@]}"|gt_cmd