#!/usr/bin/env bash
lockfile=/tmp/lockfile 
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null; 
then trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT KILL  
while true  
do 
###################
###################
set -e
#VARS
fln=''
lln=''
s='' #строка для поиска
f='' #файл для парсинга
flnfl='/opt/fln'
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
#Находим номер строки , с которой парсим лог, если файла со строкой не(наример первый запуск скрипта, то создаем его)
if [[ ! -f $flnfl ]]; then touch $flnfl && echo '1'>$flnfl;
	else read fln < $flnfl
 fi 
#Берем номер последней строки в файле
lln=$(awk 'END {print NR}' $f )
#запишем последнюю обработанную строку в файл со первой строкой
#echo $lln > $flnfl
#т.к. файл статичный делаю заглушку
echo 100 > $flnfl
cnt=$(awk 'NR>='$fln' && NR<='$lln''  $f | awk /$s/|wc|awk '{print $1}')
printf '%b' "NASHEL $cnt RAZ"

###############################33
################################
exit;
done  
rm -f "$lockfile"  
trap - INT TERM EXIT KILL 
else  
echo "Hold by $(cat $lockfile)"  
fi 
