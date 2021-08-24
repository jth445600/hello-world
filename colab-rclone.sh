#!/bin/bash

#使用方法 
#wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/jth445600/hello-world/master/colab-rclone.sh" && chmod +x install.sh && bash install.sh

bash <(wget -qO- https://git.io/gclone.sh)

wget https://445600.ml/folderrclone.zip

unzip folderrclone.zip

#curl https://rclone.org/install.sh | sudo bash

wget https://github.com/zxbu/webdav-aliyundriver/releases/download/v2.4.1/webdav-2.4.1.jar

#sudo yum install java-11-openjdk  -y || sudo  apt install  openjdk-11-jdk -y
 
nohup sudo java -jar webdav-2.4.1.jar --aliyundrive.refresh-token="4c0dcdd1d097410882fc46bdd4af62f5" --server.port="8090"  &

sudo apt install screen vim nano  -y 

mkdir /home/user/.config/rclone

#touch /home/user/.config/rclone/rclone.conf

cat > /home/user/.config/rclone/rclone.conf  <<-EOF
[001]
type = drive
scope = drive
service_account_file = /home/user/folderrclone/accounts/01928dfff2546b1a1196e85fc3a6e3578e364240.json
service_account_file_path = /home/user/folderrclone/accounts/
team_drive = 0AIYFu0InGFYtUk9PVA
 [aliyun]
type = webdav
url = http://localhost:8090
vendor = other
user = admin
pass = fybMlbiIqw0zCAqDwN4x3O6qsIw2
bearer_token = 445600


EOF

# mdkir aliyun

# rclone mount aliyun: aliyun --allow-other --allow-non-empty --vfs-cache-mode writes &

ps aux | grep webdav


screen -S aliyun

echo "gclone copy aliyun:  001:aliyun -P -vv" 
