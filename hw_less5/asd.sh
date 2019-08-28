#!/bin/sh
pid='18931'
IFS_prev="$IFS"
IFS=$'\n'
A=$(cat /proc/$pid/stat)
IFS=$IFS_prev
echo $A
/usr/lib64/chromium-browser/chromium-browser --type=renderer --field-trial-handle=14699783256146072634,9212023872125414761,131072 --lang=en-US --enable-offline-auto-reload