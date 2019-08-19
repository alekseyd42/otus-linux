#!/usr/bin/env bash
test1='test1'
test2='test2'
test3='test3'
rez=()
rez+=( $test1 )
rez+=( $test2 )
rez+=( $test3 )
echo '======'
IFS=$'\n'
echo "${rez[*]}"
mail -s "Script done" dubinskiy.a  
