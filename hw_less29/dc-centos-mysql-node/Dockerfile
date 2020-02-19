FROM centos:latest

COPY ["start.sh","./"]

RUN rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm && \
    dnf makecache -y && \
    dnf module disable mysql -y && \
    dnf install mysql-community-server.x86_64 mysql-shell -y && \
    echo "user=mysql" >> /etc/my.cnf && \
    rm -rf /var/lib/mysql/ && \
    mysqld --initialize-insecure && \
    ln -sf /dev/stderr /var/log/mysqld.log && \
    chown mysql:mysql /var/log/mysqld.log
    
EXPOSE 3306
CMD ["./start.sh"]
