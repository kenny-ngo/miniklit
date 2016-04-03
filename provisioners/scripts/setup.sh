#!/bin/sh
####
# setup.sh (c) Kenny Ngo
####
set -x

####
# Sanity scripts / configuration files
####
dos2unix /home/klit/miniklit.sh
dos2unix /home/klit/park.sh
dos2unix /home/klit/my.cnf
dos2unix /home/klit/php.ini
dos2unix /home/klit/nginx.conf
dos2unix /home/klit/nginx.tpl

####
# Prepare NGINX
####
mkdir -p /opt/miniklit/nginx/data
mkdir -p /opt/miniklit/nginx/logs
mkdir -p /opt/miniklit/nginx/conf
mv /home/klit/nginx.conf /opt/miniklit/nginx/
mv /home/klit/nginx.tpl /opt/miniklit/nginx/
chmod a+x /home/klit/park.sh

####
# Prepare MariaDB
####
mkdir -p /opt/miniklit/mariadb/data
mkdir -p /opt/miniklit/mariadb/logs
mv /home/klit/my.cnf /opt/miniklit/mariadb/
cd /usr/local/mariadb/
./scripts/mysql_install_db --user=klit --basedir=/usr/local/mariadb --datadir=/opt/miniklit/mariadb/data

####
# Prepare PHP7
####
mkdir -p /opt/miniklit/php/opcache
mkdir -p /opt/miniklit/php/logs
mv /home/klit/php.ini /opt/miniklit/php/

####
# Deploy Control Script
####
mkdir -p /opt/miniklit/
mv /home/klit/miniklit.sh /opt/miniklit/miniklit.sh
chmod a+x /opt/miniklit/miniklit.sh

filetool.sh -b sda1

exit 0
