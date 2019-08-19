#!/usr/bin/env bash
arr0=(1 2 "rest" 3 4)
echo ${arr0[@]}
#for ind in ${!arr0[@]}
##do
#echo $ind
#done
#IP
awk '{print $1}' access.log|sort | uniq -c|sort -nr |head   
#req
awk '/GET/ {print $11}' access.log |awk /http/|sort|uniq -c | sort -nr | head
#ALL CODES
awk '{print $9}' access.log |sort|uniq -c | sort -nr | head


#!/usr/bin/env bash
#Timestamp
#awk 'NR == '1' P{print $4}' ./access.log|awk -F "/" '{print $3}'>fl
rez0=()
ts=$(cat fl)
fl=$(grep -n $ts access.log | awk -F ":" {'print $1'})
ll=$(wc access.log |awk '{print $1}')
for ((i = $fl; i <= $ll; i++))
do
rez=$(awk 'NR == '$i' {print $1" "$9 " "$11 }' ./access.log)
rez0+=("$rez")
done
#echo  ${rez0[@]}
awk '{print $1}' ${rez[@]}|sort | uniq -c|sort -nr |head   


#old
#fl=$(grep -n $ts $logfile | awk -F ":" {'print $1'})
