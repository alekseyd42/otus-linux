#!/usr/bin/env bash
set -e
##Проверяем наличие параметров переданных скрипту
##Functions
#Хэлп.как использовать скрипт
function help {
    echo 'unit.sh -s <searchstring> -f <filepath>'
}
#проверяем входные параметры
function chk_param() {
    #if [[ -n $1 ]]; then echo 'Wrong options1' && exit 1;fi
    if [ $1 = 0 ];then help && exit 1;fi
    if [[ $2 != '-s' || $3 != '-f' ]]; then help && exit 1;fi
    if [[ ! -f $4 ]];then echo 'Wrong filepath' && exit 1;fi    
}
##Script
chk_param $# $1 $3 $4
#работаем с опциями
while getopts ":s:f:" opt; 
    do
        case "$opt" in
            s) s=$OPTARG;
            ;;
            f) f=$OPTARG;
            ;;
        esac
    done
if [[ ! -f /opt/fln ]]; then touch /opt/fln && echo '1'>/opt/fln;
else echo 1
 fi 