#!/usr/bin/env bash
pid="6468" 
if [ -d /proc/$pid ];then 
        stt=$(awk '{print $19 }' /proc/$pid/stat ) 
            printf '%b\n' $stt
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