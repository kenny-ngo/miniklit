#!/bin/sh
####
# /etc/init.d/miniklit.sh
# Kenny Ngo - 04/01/2016
####
[ $(id -u) = 0 ] || { echo "You need to be root" ; exit 1; }

start_nginx(){
   [ -f /opt/miniklit/conf/nginx.conf ] || { echo "Missing nginx configuration" ; exit 1; }
   echo -n "Starting nginx"
   /usr/local/sbin/nginx -c /opt/miniklit/conf/nginx.conf
}
start_mariadb(){
   [ -f /opt/miniklit/mariadb/data ] || { echo "Missing mariadb data" ; exit 1; }
   echo "Starting mariadb"
   /usr/local/mariadb/bin/mysqld --user=klit --datadir=/opt/miniklit/mariadb/data --basedir=/usr/local/mariadb &
}
start_php(){
   echo "Starting php-cgi"
   /usr/local/bin/php-cgi -b 127.0.0.1:9000&
}
stop_nginx(){
   if pidof nginx>/dev/null; then
        echo "Stopping nginx"
        kill $(pidof nginx)
   fi
}
stop_mariadb(){
   if pidof mysqld>/dev/null; then
        echo -n "Stopping mysqld"
        kill $(pidof mysqld)
   fi
}
stop_php(){
   if pidof php-cgi>/dev/null; then
        echo "Stopping php-cgi"
        kill $(pidof php-cgi)
   fi
}
restart_nginx(){
   stop_nginx
   start_nginx
}
restart_mariadb(){
   stop_mariadb
   start_mariadb
}
restart_php(){
   stop_php
   start_php
}
start() {
   start_mariadb
   start_php
   start_nginx
}
restart() {
   stop
   start
}
stop() {
   stop_nginx
   stop_php
   stop_mariadb
}

case $1 in
   start) start;;
   stop) stop;;
   restart) restart;;
   *) echo "Usage $0 {start|stop|restart}"; exit 1
esac
