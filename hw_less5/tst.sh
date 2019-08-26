#!/bin/bash
#file='/proc/22407/stat'
#a=$(awk '{print $14}' $file)
#b=$(awk '{print $15}' $file)
#d=$(awk '{print $16}' $file)
#e=$(awk '{print $17}' $file)
#echo $a' :'$b' :'$d' :'$e     
#let "c=(a+b+e+d)/100"
#echo $c
#let "sec=c%60"
#let "min=c/60%60"
#let "hrs=c/3600"
#printf -v ts '%d:%02d:%02d' $hrs $min $sec
#echo $ts
pid='21550'
function gt_time () {
file='/proc/'$1'/stat'
a=$(awk '{print $14}' $file)
b=$(awk '{print $15}' $file)
c=$(awk '{print $16}' $file)
d=$(awk '{print $17}' $file)
let "milsec=(a+b+c+d)"        
let                
let             
let    
#printf -v rez '%02d:%02d' $hrs $min 
#echo $rez
echo $sec  $min $hrs
}
tm=$(gt_time $pid)
echo $tm
