#!/bin/bash

echo I am provisioning mysql...
yum -y install mysql-server
/etc/init.d/mysqld start
chkconfig mysqld on
mysql -e "create database foreman;"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;"

echo I am provisioning foreman...
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6*.rpm
curl http://dev.centos.org/centos/6/SCL/scl.repo  > /etc/yum.repos.d/scl.repo
yum -y localinstall http://yum.theforeman.org/releases/${foreman_release}/el6/x86_64/foreman-release.rpm && yum -y install foreman foreman-compute foreman-cli foreman-mysql2

yum -y install python-pip --enablerepo=epel
pip install cloudmonkey
gem install jgrep

rm -f /etc/foreman/database.yml
cat > /etc/foreman/database.yml <<DATABASE
production:
  adapter: mysql2
  database: foreman
  username: root 
  password: password
  host: 127.0.0.1 
  socket: "/var/run/mysqld/mysqld.sock"
DATABASE
foreman-rake db:migrate
foreman-rake db:seed

chkconfig foreman on

