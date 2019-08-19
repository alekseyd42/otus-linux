#/usr/bin/env bash
lockfile=/tmp/lockfile
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
then   trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT KILL   
while true   
    do
       echo 123  
    done  
rm -f "$lockfile"  
trap - INT TERM EXIT KILL
else  
echo "Failed to acquire lockfile: $lockfile."  
echo "Held by $(cat $lockfile)" 
fi