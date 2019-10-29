#!/usr/bin/env bash 
green=`tput setaf 2`
reset=`tput sgr0`
p="ping -c 2"
echo -e "${green}ping routers_net interfaces${reset}"
$p 192.168.255.1
$p 192.168.255.2
$p 192.168.255.5
$p 192.168.255.6
$p 192.168.255.9
$p 192.168.255.10
echo -e "${green}ping local_net interfaces${reset}"
$p 192.168.0.1
$p 192.168.1.1
$p 192.168.2.1
echo -e "${green}ping servers${reset}"
$p 192.168.0.2
$p 192.168.1.2
$p 192.168.2.2
echo -e "${green}ping MAIL.RU${reset}"
$p mail.ru