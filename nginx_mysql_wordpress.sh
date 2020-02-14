#!/bin/bash
echo "Berikut Adalah Aplikasi yang akan diinstal: "
echo " 1. nginx"
echo " 2. php7.2"
echo " 3. php7.2-fpm"
echo " 4. php7.2-mysql"
echo " 5. mysql-server"
echo " 6. php7.2-curl php7.2-gd php7.2-intl php7.2-mbstring php7.2-soap php7.2-xml php7.2-xmlrpc php7.2-zip"
echo " 7. wordpress package"
read -p "Apakah kamu yakin? (Y/n) " pilih1;
if [ $pilih1 == 'y' ] || [ $pilih1 == 'Y' ];
then
set -e
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo "Update Repository"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    sudo apt-get update
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo "Melakukan Installasi Webserver"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    sudo apt-get install -y nginx php7.2 php7.2-fpm php7.2-mysql php7.2-curl php7.2-gd php7.2-intl php7.2-mbstring php7.2-soap php7.2-xml php7.2-xmlrpc php7.2-zip
    echo -e "\033[1;32m <<=======================================>>\033[0m" 
    echo -e "\033[1;32m <<=======================================>>\033[0m"   
    echo "Melakukan Installasi Database Server"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    sudo apt-get install -y mysql-server
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    read -p "Maukah kamu mencoba fungsionalnya? (Y/n) " pilih2; 
        if [ $pilih2 == 'y' ] || [ $pilih2 == 'Y' ];
            then
            set -e
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "download dan config wordpress package"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                cd 
                mkdir testweb
                cd ~/testweb
                curl -LO https://wordpress.org/latest.tar.gz
                tar xzvf latest.tar.gz
                cp wordpress/wp-config-sample.php wordpress/wp-config.php
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "<<melakukan unzip dan memindahkan hasil download ke /var/www/>>"
                sudo cp -a wordpress/. /var/www/wordpress
                

                echo "PERSIAPAN SELESAI"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "membuat user pada mysql"
                newuser=wordpress
                passnewuser=1234567890
				passroot=xxx
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
#                sudo mysql -u root -p$passroot -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
                sudo mysql -u root -p$passroot -e "create user '$newuser'@'localhost' identified by '$passnewuser';"
                sudo mysql -u root -p$passroot -e "grant all privileges on *.* to '$newuser'@'localhost';"

                echo "user $newuser telah ditambahkan, silahkan dicek kembali :"
                sudo mysql -u root -p$passroot -e "select user from mysql.user;"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "sekarang kita akan membuat database baru menggunakan user $newuser"
                dbname=dbwordpress
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
#                echo "masukkan password user $newuser : "
                sudo mysql -u $newuser -p$passnewuser -e "create database $dbname;"
                sudo mysql -u $newuser -p$passnewuser -e "show databases;"
                echo "database telah berhasil dibuat silahkan cek kembali diatas"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"

                cd /var/www/wordpress
                
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php

sed -i "s/database_name_here/$dbname/g" wp-config.php
sed -i "s/username_here/$newuser/g" wp-config.php
sed -i "s/password_here/$passnewuser/g" wp-config.php
echo "define('FS_METHOD', 'direct');" >>wp-config.php

#                sudo mysql -u $newuser -p$passnewuser $dbname < dump.sql                         
               
               
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "configurasi nginx"
                cd /etc/nginx/sites-available/
                sudo cp default wordpress


                sudo tee wordpress > /dev/null <<EOF 
                server {
                    listen 80 default_server;
                    listen [::]:80 default_server;

                    root /var/www/wordpress;
                    index index.php index.html index.htm index.nginx-debian.html;

                    server_name server_domain_or_IP;

                    location / {
                         try_files \$uri \$uri/ /index.php$is_args$args;
                    }
                    
                    location = /favicon.ico { log_not_found off; access_log off; }
                    location = /robots.txt { log_not_found off; access_log off; allow all; }
                    location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
                       expires max;
                       log_not_found off;
                    }

                    location ~ \.php$ {
                        include snippets/fastcgi-php.conf;
                        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
                    }

                    location ~ /\.ht {
                        deny all;
                    }
                }
                
                
EOF

#
                cd /etc/nginx/sites-enabled/
                sudo touch delete
                sudo rm /etc/nginx/sites-enabled/*
                sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                sudo nginx -t
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                sudo systemctl reload nginx
            
                echo ""
                IPserver=`hostname -I`
                echo "instalasi selesai sekarang silahkan buka browser dan ketikkan alamat ip $IPserver "
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                read -p "Delete web testing yang telah diinstal?? (Y/n) " pilih3; 
                if [ $pilih3 == 'y' ] || [ $pilih3 == 'Y' ];
                       then
                         set -e
                            echo -e "\033[1;32m <<=======================================>>\033[0m"            
                            echo "delete script web sederhana"
                            cd
                            rm -r testweb
                            sudo rm -r /var/www/html/sosial-media-master
                            sudo rm /etc/nginx/sites-enabled/test                            
                            sudo rm /etc/nginx/sites-available/test
                            echo -e "\033[1;32m <<=======================================>>\033[0m"
                            echo "delete user pada mysql"     
                            sudo mysql -u root -p$passroot -e "drop database $dbname;"   
                            sudo mysql -u root -p$passroot -e "drop user '$newuser'@'localhost';"
                            echo -e "\033[1;32m <<=======================================>>\033[0m"
                            echo "SELESAI"
                            echo ""
                            echo "delete ok "
                        else
                                echo "Installasi Selesai"
                fi
            else
            echo "Installasi Selesai"
        fi
else
echo "Installasi dibatalkan"
echo -e "\033[1;32m <<================================================================>>\033[0m"
exit
fi



