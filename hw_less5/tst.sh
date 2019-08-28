#!/usr/bin/env bash
lspid=$(ls /proc | awk /[0-9]/|sort -n)
for pid in ${lspid[@]}
    do
        if [ -d /proc/$pid ];then 
        st=$(awk '{print $3}' /proc/$pid/stat)
        stt=$(awk '{print $19}' /proc/$pid/stat)
            if [ "$stt" -lt 0 ]
            then
             stt="<"
                elif [ "$stt" -gt 0 ]    
                  then stt="N"
                elif [ "$stt" == 0 ]
                  then stt=''
            fi       
        printf '%b\n' $pidd' '$st$stt' '$nm
        fi
    done
# awk -F"[][()]" '{print $3 }' /proc/18931/stat |awk '{print $1}'
