#!/usr/bin/env bash
#/usr/bin/env bash
lockfile=/tmp/lockfile
rezfile=/tmp/rezfile
##защита от двойного запуска
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
then   trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT KILL   
while true   
do
    #Timestamp
    #Указываем логфайл для парсинга
    logfile='access.log' 
    #Проверяем существование файла с таймстампом
    #Если файла нет, то создаем его и помещаем в него тиаймстамп первой строки из файла access.log
    if [ ! -f fl ]
    then 
    touch fl
    echo $(awk 'NR == '1' {print $4}' $logfile)|cut -d "/" -f3 >fl
    ts=$(cat fl)
    fl=$(awk /$ts/{'print NR'} $logfile)
    #Если файл есть, то читаем таймстамп и находим номер строки , с котрого будем парсить лог
    else
    ts=$(cat fl)
    fl=$(awk /$ts/'{print NR}' $logfile)
    fi
    #находим в логфайле номер последней строки, до которой будем читать лог и значение timestamp последней строки
    ll=$(wc $logfile |awk '{print $1}')
    lts=$(awk 'NR == '$ll' {print $4}' $logfile|cut -d "/" -f3)
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
    awk {'print $7'}|sort|uniq -c|sort -nr|head
    }
     #аргументы для поиска всех кодов ошибок
    function errors {
    awk {'print $9'}|awk /[4-5][0-9]/|sort|uniq -c|sort -nr
    }
     #аргументы для поиска всех кодов 
    function backcodes {
    awk {'print $9'}|sort|uniq -c|sort -nr
    }
    #отправка почты 
    function sendmail {
    mail -s "Rez" vagrant < $rezfile
    rm -rf $rezfile
    }

#Скрипт
    rf=$(readfile)
    IFS='\n'
    printf "Start time:"$ts'\n' >> $rezfile	
    printf "End time:"$lts'\n' >> $rezfile
    printf "TOP IP:"'\n' >> $rezfile
    printf '\n' >> $rezfile
    echo "${rf[@]}"|top_ip >> $rezfile
    printf "TOP_QUERY:"'\n' >> $rezfile
    echo "${rf[@]}"|top_query >> $rezfile
    printf "All Errors:"'\n' >> $rezfile
    echo "${rf[@]}"|errors >> $rezfile
    printf "ALL CODES:"'\n' >> $rezfile
    echo "${rf[@]}"|backcodes >> $rezfile
    sendmail
 #Конец скрипта   
    exit;
done  
rm -f "$lockfile"  
trap - INT TERM EXIT KILL
else  
echo "Hold by $(cat $lockfile)" 
fi
