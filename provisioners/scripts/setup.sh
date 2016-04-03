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
mkdir -p /opt/miniklit/nginx/logs
mv /home/klit/nginx.conf /opt/miniklit/nginx/

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
