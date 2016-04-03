####
# setup.sh
# Kenny Ngo - 03/25/2016
####
set -x

####
# Sanity scripts / configuration files
####
dos2unix /home/klit/miniklit.sh
dos2unix /home/klit/my.cnf
dos2unix /home/klit/php.ini
dos2unix /home/klit/nginx.conf

####
# Prepare NGINX
####
mkdir -p /opt/miniklit/nginx/data
mkdir -p /opt/miniklit/nginx/conf
mkdir -p /opt/miniklit/nginx/logs

####
# Prepare MariaDB
####
mkdir -p /opt/miniklit/mariadb/data
mkdir -p /opt/miniklit/mariadb/conf
mkdir -p /opt/miniklit/mariadb/logs

####
# Prepare PHP7
####
mkdir -p /opt/miniklit/php/opcache
mkdir -p /opt/miniklit/php/logs

####
# Deploy Configuration and Template
####
mv /home/klit/my.cnf /opt/miniklit/mariadb/conf/
mv /home/klit/nginx.conf /opt/miniklit/nginx/conf/
mv /home/klit/php.ini /opt/miniklit/php/conf/


####
# Deploy Control Script
####
mkdir -p /opt/miniklit/
mv /home/klit/miniklit.sh /opt/miniklit/miniklit.sh
chmod a+x /opt/miniklit/miniklit.sh

filetool.sh -b sda1

exit 0
