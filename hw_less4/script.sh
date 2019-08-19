#!/usr/bin/env bash
#/usr/bin/env bash
##защита от двойного запуска
lockfile=/tmp/lockfile
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
then   trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT KILL   
while true   
do
    #Timestamp
    #awk 'NR == '1' P{print $4}' ./access.log|awk -F "/" '{print $3}'>fl
    #Указываем логфайл для парсинга
    logfile='access.log' 
    #Проверяем существование файла с таймстампом
    #Если файла нет, то создаем его и помещаем в него тиаймстамп первой строки из файла access.log
    if [ ! -f fl ]
    then 
    touch fl
    echo $(awk 'NR == '1' {print $4}' access.log)|cut -d "/" -f3 >fl
    #Если файл есть, то читаем таймстамп и находим номер строки , с котрого будем парсить лог
    else
    ts=$(cat fl)
    fl=$(awk /$ts/'{print NR}' $logfile)
    fi
    #находим в логфайле номер последней строки, до которой будем читать лог
    ll=$(wc $logfile |awk '{print $1}')
    #функция формирует вывод,по временному диапазону , который мы будем парсить(от fl до ll)
    function readfile {
    for ((i = $fl; i <= $ll; i++))
    do
    sed -n ''$i'p' $logfile
    done
    }
    #аргументы для поиска топ 10 ИП 
    function top_ip {
    awk {'print $1'}|sort|uniq -c|sort -nr|head
    }
    #аргументы для поиска топ 10 запрашиваемых страниц
    function top_query {
    awk '{print $7}'|sort|uniq -c|sort -nr|head
    }

    rf=$(readfile)
    IFS='\n'
    printf "TOP IP:"'\n' 
    printf '\n'
    echo "${rf[@]}"|top_ip
    printf "TOP_QUERY:"'\n'
    echo "${rf[@]}"|top_query
    
    
 #Конец скрипта   
    exit;
done  
rm -f "$lockfile"  
trap - INT TERM EXIT KILL
else  
echo "Hold by $(cat $lockfile)" 
fi