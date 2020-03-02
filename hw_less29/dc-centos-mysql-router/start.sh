#!/usr/bin/env bash
##Functions
###Test mysql ready to connect
function tstcon ()
{
var=$(mysqlsh --uri="root@$1" -p"password" --no-wizard --js -i -e "dba.verbose" 2>&1|sed '$!d')
i="0"
        while  [[ $var != "0" ]];do
                if  [[ "$i" -le  "4" ]];then
                        let i=i+1
                        var=$(mysqlsh --uri="root@$1" -p"password" --no-wizard --js -i -e "dba.verbose" 2>&1|sed '$!d')
                        echo "No connect to $1.Waitin 30 sec"
                        sleep 20
                else
                        echo "Connection restored or service not avalible"
                        exit 0
                fi
        done
}

##Config nodes 
if [ ! -f /mysql_router/mysqlrouter.conf ]; then
tstcon mysql0
mysqlsh --uri="root@mysql0" -p"password" --no-wizard --js -i -e "dba.configureInstance()"
mysqlsh --uri="root@mysql1" -p"password" --no-wizard --js -i -e "dba.configureInstance()"
mysqlsh --uri="root@mysql2" -p"password" --no-wizard --js -i -e "dba.configureInstance()"
var0=$(docker service ls |grep mysql[0-9]|awk '{print $2}')
for service in ${var0[@]}
do
docker service update --force $service
done

docker service update $(docker service ls -q) --force
##Create cluster
tstcon mysql0

mysqlsh --uri="root@mysql0" -p"password" --no-wizard --js -i -e " cl=dba.createCluster('mysql_cl') "
## add nodes
tstcon mysql1
mysqlsh --uri="root@mysql0" -p"password" --no-wizard --js -i -e " (cl=dba.getCluster());cl.addInstance({user:'root', host:'mysql1', port:'3306', password:'password'},{recoveryMethod:'clone'}) "
tstcon mysql2
mysqlsh --uri="root@mysql0" -p"password" --no-wizard --js -i -e " (cl=dba.getCluster());cl.addInstance({user:'root', host:'mysql2', port:'3306', password:'password'},{recoveryMethod:'clone'}) "
passfile=$(mktemp)
echo "password" >  "$passfile"
mysqlrouter --user=root --bootstrap root@mysql0:3306 -d mysql_router --force < "$passfile"
fi
tstcon mysql0
tstcon mysql1
tstcon mysql2
mysqlrouter -c /mysql_router/mysqlrouter.conf

