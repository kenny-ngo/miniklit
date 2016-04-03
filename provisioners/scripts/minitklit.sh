#!/bin/sh
####
# /opt/miniklit/miniklit.sh
# Kenny Ngo - 04/01/2016
####
[ $(id -u) = 0 ] || { echo "You need to be root" ; exit 1; }

####
# Tweaking
####
export PHP_FCGI_CHILDREN=5
export PHP_FCGI_MAX_REQUESTS=500

# optimized value for 4GB + 4GB Swap
# ulimit -n 62500
ulimit -Hn 65535
ulimit -Sn 65535


start_nginx(){
   [ -f /opt/miniklit/conf/nginx.conf ] || { echo "Missing nginx configuration" ; exit 1; }
   echo -n "Starting nginx"
   /usr/local/sbin/nginx -c /opt/miniklit/conf/nginx.conf
}
start_mariadb(){
   [ -f /opt/miniklit/mariadb/data/ibdata1 ] || { echo "Missing mariadb data" ; exit 1; }
   echo "Starting mariadb"
   /usr/local/mariadb/bin/mysqld --user=klit --datadir=/opt/miniklit/mariadb/data --basedir=/usr/local/mariadb &
}
start_php(){
   echo "Starting php-cgi"
   /usr/bin/php-cgi -b 127.0.0.1:9000&
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

   start_nginx) start_nginx;;
   stop_nginx) stop_nginx;;
   restart_nginx) restart_nginx;;

   start_php) start_php;;
   stop_php) stop_php;;
   restart_php) restart_php;;

   start_mariadb) start_mariadb;;
   stop_mariadb) stop_mariadbp;;
   restart_mariadb) restart_mariadb;;

   *) echo "Usage $0 {start|stop|restart}"; exit 1
esac
