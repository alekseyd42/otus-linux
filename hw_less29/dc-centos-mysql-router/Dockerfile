FROM centos:latest

COPY ["start.sh","./"]

RUN rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm && \
    dnf makecache -y && \
    dnf module disable mysql -y && \
    dnf install mysql-router mysql-shell -y && \
    curl  https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo && \
    dnf makecache && \
    dnf install docker-ce -y --nobest
ENTRYPOINT ["/start.sh"]        
CMD [""]
