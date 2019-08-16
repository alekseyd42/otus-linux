#!/usr/bin/env bash
arr0=(1 2 "rest" 3 4)
echo ${arr0[@]}
#for ind in ${!arr0[@]}
##do
#echo $ind
#done
awk '{print $1}' $1  | uniq -c|sort -nr| head
awk '/GET/ {print $11}' $1 |awk /http/|uniq -c | sort -nr | head