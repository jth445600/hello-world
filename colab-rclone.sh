#!/bin/bash

curl https://rclone.org/install.sh | sudo bash

wget https://github.com/zxbu/webdav-aliyundriver/releases/download/v2.4.1/webdav-2.4.1.jar
 
nohup sudo java -jar webdav-2.4.1.jar --aliyundrive.refresh-token="4c0dcdd1d097410882fc46bdd4af62f5" --server.port="8090"  &

apt install screen -y 

cat > /home/user/.config/rclone/rclone.conf  <<-EOF
 [aliyun]
type = webdav
url = http://localhost:8090
vendor = other
user = admin
pass = fybMlbiIqw0zCAqDwN4x3O6qsIw2
bearer_token = 445600

[001]
type = drive
scope = drive
token = {"access_token":"ya29.a0ARrdaM_C8JD4eyhk12REKyybPh_FFYsl8a4gIOlMpta0o-RcnBSKUnhj1j4ghuAp7jysRelQHjilxZ-YUdk99KANV-eO3nT2eykg7nU8T4TPpbum0P7XYLhvFyriRrkGWsT1U-E5fyczpZnOsg3maNSFw5Mi","token_type":"Bearer","refresh_token":"1//0eJyHtnUmC7bOCgYIARAAGA4SNwF-L9IreffmEJ4JjYc-IK-HCIrl9BnGP7xxHX667vYidbYaHTPFSQncEPVi7-34oC4zobzcKsw","expiry":"2021-08-23T17:48:59.3374718Z"}
team_drive = 0AIWSXfHbc9J0Uk9PVA
root_folder_id = 

EOF


