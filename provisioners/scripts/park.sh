#!/bin/sh
####
# park.sh (c) Kenny Ngo
####

[ -z "$1" ] || { echo "Usage: $0 domain.com" ; exit 1; }

mkdir -p /opt/miniklit/nginx/data/$1
sed "s/%domain%/$1/g" /opt/miniklit/nginx/nginx.tpl > /opt/miniklit/nginx/conf/$1.conf

echo "Need to restart nginx: sudo /opt/miniklit/miniklit.sh restart_nginx"
