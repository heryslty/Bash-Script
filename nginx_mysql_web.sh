#!/bin/bash

 

echo "Berikut Adalah Aplikasi yang akan diinstal: "
echo " 1. nginx"
echo " 2. php7.2"
echo " 3. php7.2-fpm"
echo " 4. php-mysql"
echo " 5. mysql-server"
echo " 6. aplikasi zip"
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
    sudo apt-get install -y nginx php7.2 php7.2-fpm php-mysql
    echo -e "\033[1;32m <<=======================================>>\033[0m" 
    echo -e "\033[1;32m <<=======================================>>\033[0m"   
    echo "Melakukan Installasi Database Server"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    sudo apt-get install -y mysql-server
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo "instalasi zip"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    sudo apt install -y zip
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    echo -e "\033[1;32m <<=======================================>>\033[0m"
    read -p "Maukah kamu mencoba fungsionalnya? (Y/n) " pilih2; 
        if [ $pilih2 == 'y' ] || [ $pilih2 == 'Y' ];
            then
            set -e
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "download script web sederhana"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                cd 
                mkdir testweb
                cd ~/testweb
                wget https://github.com/sdcilsy/sosial-media/archive/master.zip
                unzip master.zip
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "<<melakukan unzip dan memindahkan hasil download ke /var/www/html/>>"
#                sudo rm -r /var/www/html/*
                sudo mv sosial-media-master /var/www/html/.
                echo "PERSIAPAN SELESAI"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "membuat user pada mysql"
                read -p "nama user baru : " newuser;
                read -p "masukkan password untuk user baru : " passnewuser;
				read -p "masukkan password root : " passroot;
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                sudo mysql -u root -p$passroot -e "create user '$newuser'@'localhost' identified by '$passnewuser';"
                sudo mysql -u root -p$passroot -e "grant all privileges on *.* to '$newuser'@'localhost';"

                echo "user $newuser telah ditambahkan, silahkan dicek kembali :"
                sudo mysql -u root -p$passroot -e "select user from mysql.user;"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "sekarang kita akan membuat database baru menggunakan user $newuser"
                read -p "masukkan nama database : " dbname;
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
#                echo "masukkan password user $newuser : "
                sudo mysql -u $newuser -p$passnewuser -e "create database $dbname;"
                sudo mysql -u $newuser -p$passnewuser -e "show databases;"
                echo "database telah berhasil dibuat silahkan cek kembali diatas"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
#                echo "masukkan password $newuser untuk restore database"
                cd /var/www/html/sosial-media-master/
                sudo mysql -u $newuser -p$passnewuser $dbname < dump.sql                         
               
               
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo -e "\033[1;32m <<=======================================>>\033[0m"
                echo "configurasi nginx"
                cd /etc/nginx/sites-available/
                sudo cp default test
#                read -p "masukkan directory file aplikasi web : " directory


                sudo tee test > /dev/null <<EOF 
                server {
                    listen 80 default_server;
                    listen [::]:80 default_server;

                    root /var/www/html/sosial-media-master;
                    index index.php index.html index.htm index.nginx-debian.html;

                    server_name server_domain_or_IP;

                    location / {
                        try_files \$uri \$uri/ =404;
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
                sudo ln -s /etc/nginx/sites-available/test /etc/nginx/sites-enabled/
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



