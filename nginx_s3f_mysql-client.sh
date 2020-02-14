#!/bin/bash
sudo apt update
sudo apt install -y mysql-client
sudo apt install -y nginx php7.2 php7.2-fpm php7.2-mysql
sudo apt install -y awscli
sudo apt install -y automake autotools-dev fuse g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure
make
sudo make install
which s3fs
#baca https://geraldalinio.com/aws/s3/install-s3fs-and-mount-s3-bucket-to-ec2-ubuntu-18-04/
echo ACCESS_KEY_ID:SECRET_ACCESS_KEY > /home/ubuntu/.passwd-s3fs
chmod 600 /home/ubuntu/.passwd-s3fs 
sudo mkdir -p /var/www/sosial-media-master
#dibawah ini adalah command untuk connect ke s3 bucket
sudo s3fs bcprodheri /var/www/sosial-media-master -o passwd_file=/home/ubuntu/.passwd-s3fs -o url=https://s3.ap-southeast-1.amazonaws.com -ouid=1001,gid=1001,allow_other
#sudo s3fs NAMA_BUCKET /var/www/directory_tempat_bucket_di_mounting -o passwd_file=/home/ubuntu/.passwd-s3fs -o url=https://s3.disesuaikanZoneBucketBerada.amazonaws.com -ouid=1001,gid=1001,allow_other


#cara masuk ke console RDS bisa pakai command ini
#mysql -h Link_end_point_RDS -u User_RDS -pPassword_tanpa_spasi

cd /etc/nginx/sites-available/
sudo cp default cilsy    

                sudo tee cilsy > /dev/null <<EOF 
                server {
                    listen 80 default_server;
                    listen [::]:80 default_server;

                    root /var/www/sosial-media-master;
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


cd /etc/nginx/sites-enabled/
sudo touch delete
sudo rm /etc/nginx/sites-enabled/*
sudo ln -s /etc/nginx/sites-available/cilsy /etc/nginx/sites-enabled/
sudo systemctl reload nginx.service
sudo systemctl reload php7.2-fpm.service
