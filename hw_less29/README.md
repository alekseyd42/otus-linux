### MYSQL Innodb-cluster
Поднимаем Innodb cluster в докере с docker-compose и docker-swarm


metadata_exists=$(mysqlsh --uri="$MYSQL_USER"@"$MYSQL_HOST":"$MYSQL_PORT" -p"$MYSQL_ROOT_PASSWORD" --no-wizard --js -i -e "dba.getCluster( '${CLUSTER_NAME}' )" 2>&1 | grep "<Cluster:$CLUSTER_NAME>")


var1=$(mysqlsh --uri="root@mysql0" -p"password" --no-wizard --js -i -e  "dba.getCluster( 'mysql_cl' )"| grep "<Cluster:mysql_cl>")
http://insidemysql.com/mysqlvp/idc/


mysqlsh --uri=root@172.28.0.13:6446
(dba.getCluster()).status()
(dba.getCluster()).rescan()