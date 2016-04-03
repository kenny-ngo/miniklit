server {
   listen  80;
   server_name  %domain% www.%domain%;

   access_log /opt/miniklit/nginx/logs/%domain%/access.log  main;

   location / {
      root   /opt/miniklit/nginx/data/%domain%;
      index  index.php index.html index.htm;
   }

   error_page   500 502 503 504  /50x.html;
   location = /50x.html {
      root   /usr/local/nginx/html;
   }

   # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
   location ~ \.php$ {
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_index  index.php;
      fastcgi_param  SCRIPT_FILENAME  /opt/miniklit/nginx/data/%domain%$fastcgi_script_name;
      include        /usr/local/etc/nginx/fastcgi_params;
   }

   location ~ /\.ht {
      deny  all;
   }
}
