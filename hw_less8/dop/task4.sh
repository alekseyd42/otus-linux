#!/usr/bin/env bash
yum install wget epel-release -y
yum install java-1.8.0-openjdk -y
systemctl disable --now firewalld
mkdir /opt/atlassian
wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-core-8.3.3.tar.gz 
tar -zxvf atlassian-jira-core-8.3.3.tar.gz -C /opt/atlassian/
mv /opt/atlassian/atlassian-jira-core-8.3.3-standalone/* /opt/atlassian/
rm -rf /opt/atlassian/atlassian-jira-core-8.3.3-standalone/
cp /vagrant/jira.service /etc/systemd/system/
cp /vagrant/jira /etc/sysconfig
systemctl daemon-reload
systemctl start jira.service
systemctl status jira.service
