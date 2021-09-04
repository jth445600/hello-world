#!/bin/bash

#使用方法 
#wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/jth445600/hello-world/master/katacoda_gclone_onekey.sh" && chmod +x install.sh && bash install.sh
sudo yum install java-11-openjdk unzip screen vim nano -y || sudo  apt install  openjdk-11-jdk unzip screen vim nano -y

bash <(wget -qO- https://git.io/gclone.sh)  

# 安装rclone
curl https://rclone.org/install.sh | sudo bash

wget https://445600.ml/folderrclone.zip && unzip folderrclone.zip

wget https://issuecdn.baidupcs.com/issue/netdisk/LinuxGuanjia/3.5.0/baidunetdisk_3.5.0_amd64.deb

sudo dpkg -i baidunetdisk_3.5.0_amd64.deb


#curl https://rclone.org/install.sh | sudo bash

wget https://github.com/zxbu/webdav-aliyundriver/releases/download/v2.4.1/webdav-2.4.1.jar


 
nohup sudo java -jar webdav-2.4.1.jar --aliyundrive.refresh-token="7cd3872d8d284a8ab6714feaa57bd727" --server.port="8090"  &



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

[zhong]
type = onedrive
token = {"access_token":"eyJ0eXAiOiJKV1QiLCJub25jZSI6IlRsTjFjZnFMSTV1clBrYWxIamtxTlZpWU93TWtuNWZ5cDlscnBtMEY1WWMiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9jM2EyMzc1OS1iZTFjLTRmMmMtOGIxMS04N2E5ZjkzNWIzYjEvIiwiaWF0IjoxNjMwNTA5MjI3LCJuYmYiOjE2MzA1MDkyMjcsImV4cCI6MTYzMDUxMzEyNywiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkUyWmdZTWd0K1J5UmFyaDlkdmoxNmt2SlF2R1hPMmU4NlAvMHRrYkxKVlZId0diOUhEMEEiLCJhbXIiOlsicHdkIl0sImFwcF9kaXNwbGF5bmFtZSI6InJjbG9uZSIsImFwcGlkIjoiYjE1NjY1ZDktZWRhNi00MDkyLTg1MzktMGVlYzM3NmFmZDU5IiwiYXBwaWRhY3IiOiIxIiwiZmFtaWx5X25hbWUiOiJTcGl2ZXkiLCJnaXZlbl9uYW1lIjoiTWFyY2VsbGEiLCJpZHR5cCI6InVzZXIiLCJpcGFkZHIiOiIxMTIuOC4xMjguMjQiLCJuYW1lIjoiU3BpdmV5IE1hcmNlbGxhIiwib2lkIjoiNGZlMzMxZDYtOGQxYi00MTViLTk1NDYtODJhMzdiY2U2YTg5IiwicGxhdGYiOiIzIiwicHVpZCI6IjEwMDMyMDAxNzJEMTlBMjQiLCJyaCI6IjAuQVhFQVdUZWl3eHktTEUtTEVZZXAtVFd6c2RsbFZyR203WkpBaFRrTzdEZHFfVmx4QVA4LiIsInNjcCI6IkZpbGVzLlJlYWQgRmlsZXMuUmVhZC5BbGwgRmlsZXMuUmVhZFdyaXRlIEZpbGVzLlJlYWRXcml0ZS5BbGwgU2l0ZXMuUmVhZC5BbGwgcHJvZmlsZSBvcGVuaWQgZW1haWwiLCJzdWIiOiJqME44RnB5OE9aQmRaLUZTRFdHd3FWOFhkR0RCdDh4VlNkZTNQandhcFUwIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IkFTIiwidGlkIjoiYzNhMjM3NTktYmUxYy00ZjJjLThiMTEtODdhOWY5MzViM2IxIiwidW5pcXVlX25hbWUiOiJIYXJyeUB3dXpob25nMTMub25taWNyb3NvZnQuY29tIiwidXBuIjoiSGFycnlAd3V6aG9uZzEzLm9ubWljcm9zb2Z0LmNvbSIsInV0aSI6ImxjYUFHT0pnZ1VDcnRDeEo2cmh0QUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbIjY5MDkxMjQ2LTIwZTgtNGE1Ni1hYTRkLTA2NjA3NWIyYTdhOCIsIjcyOTgyN2UzLTljMTQtNDlmNy1iYjFiLTk2MDhmMTU2YmJiOCIsImYyZWY5OTJjLTNhZmItNDZiOS1iN2NmLWExMjZlZTc0YzQ1MSIsImYwMjNmZDgxLWE2MzctNGI1Ni05NWZkLTc5MWFjMDIyNjAzMyIsImYyOGExZjUwLWY2ZTctNDU3MS04MThiLTZhMTJmMmFmNmI2YyIsIjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsImZlOTMwYmU3LTVlNjItNDdkYi05MWFmLTk4YzNhNDlhMzhiMSIsIjI5MjMyY2RmLTkzMjMtNDJmZC1hZGUyLTFkMDk3YWYzZTRkZSIsImI3OWZiZjRkLTNlZjktNDY4OS04MTQzLTc2YjE5NGU4NTUwOSJdLCJ4bXNfc3QiOnsic3ViIjoiVzB1WWRIUEVlVmlub1RYZnJiLUlsYjJfZmRtMWNHeU10a3UyS3IxODZIcyJ9LCJ4bXNfdGNkdCI6MTYyOTIwNjU3Nn0.YUenJtA3BaNhYCA__XJzIso9edC5XYRIuhXzA5cGL6LWpMvDz3LdsvI2QJV2IuFXaamfXqqGJMu5Io1LcbViURE0JIBmmXT4KipVtq_nES3gGnNuJsd8agP4qafj2yy2v-iT7v5RZZFUnw67YHHmWbBPoTqJ0Do_SGoPqBsBLhHT5E5py9G6UZ73esVBIz6Ti5Mfl8wmPMyOpazR2aiHEzgppQycSksQGxPbE-EAmDYLEeYvuUYA5uYFEtMe6dDZQ7AIKSZXbGKBVFAXwyoTyNCsSAUUq5-SPDDorIsCd8YLzd6I9ZK8jVtzLdYklE51Cn5OKv0B5TJZzOgXFF_qTQ","token_type":"Bearer","refresh_token":"0.AXEAWTeiwxy-LE-LEYep-TWzsdllVrGm7ZJAhTkO7Ddq_VlxAP8.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P-wAn1yW-hfjGv8NGFkRIFcOAk9uuizRffVY3qYdj2ytu8pP9-Uq6056lMH8iESp29TuGUn5tKLHw1M9TqXrjoWvMYvPwiBZBWpG4VW-BngpPcUJ_pSeJkhI6UE6S9FzC7xb9zusW7WHRA_rCmOoat27MSU9MsAc9n_DJRtxA1cXwZyAHs4naJyGaNvB8vQtBE6LlXOoM8ChBtOMFSHrX3q9X847qrMrsrHs6LbnezJObjWWqv1EK2DQjJZR69DNfV-QnB5MORMXQ5g8Y-9KzeLOONgKAw3g9QUQe0tXJLuCOr-8yvn_OoQbkGscYFwI6pztXdQeHO6mZwLO4IaNriX4QmBcHPCrQcvmeO6o9d62LNlQPSwt-YK19mbHWNXEs1M_BKxPa3S3I5MxvxxYJ03m2xn79WWxC4nnqCLztRFDsj2SaIo2xTmRUj8tDGhNpOAa2WDzfXR4HFjz30ZlpAM7HcinkycUlMwWUE5CnasvIbxXYc49k3lCFcy_qhwvQxSDnUzEKGzluItBW7O3GI6sh0oggv9ERVMUhw4qhpHtIhuFPq7I3-5GdjUjgqR6DpWXWQTWUEy_kUYDC0XmT6KqWx-vJWPxFQ3dcFKt-CeT5Gzp82odVNywfAivI0DoynmX6_RIRifq4BLjdwfqsAQjx4lh5EY0ee2tBCIMoBs4qKl1ZI_kAW5dBmgHjvNafGAxtS1ABN8f15FgO307oroNA0qpzXmYSFJdD1HzXq8gNEBAgAz3wBQ_ocN_3guQ8nI3DZNtesx6tv-0dlhQQUbzEcyZyDdYCRqIbdkK7cjZaiYZF2n97IHObZ1r1rpdHmhHOXfzSrJSZVGGUlenrnlCf4Vyvp-HwvvIcOECE2SJ3JaE9HTsANgBiSZgg7GUL2hViU8HOt7QfJkY-zttNOmoHmgBIzdTFgxNKdJBZx10OJeinr9UIXSXHxTAQvE_nuQhz0Zwzg","expiry":"2021-09-01T18:18:47.296558473+02:00"}
drive_id = b!yprK8U_UZ06JiKne6MRIYMXhkUzAzkRDq9shw8mNce-bNWakErpCRbZBiuZbAhOS
drive_type = business


EOF

# mdkir aliyun

# rclone mount aliyun: aliyun --allow-other --allow-non-empty --vfs-cache-mode writes &

ps aux | grep webdav


echo "screen -S aliyun"

echo "gclone copy aliyun:  001:aliyun -P -vv" 

# 卸载命令（务必）：fusermount -qzu aliyun
   
# 挂载命令（下载模式）# nohup gclone mount aliyun: aliyun --allow-other --allow-non-empty --vfs-cache-mode writes &


docker run -d \
      --name clouddrive \
      --restart unless-stopped \
      -v /home/user:/CloudNAS:shared \
      -v /home/user/Downloads:/Config \
      -v /home/user/Music:/media:shared \
      -p 9798:9798 \
     --privileged \
     --device /dev/fuse:/dev/fuse \
     cloudnas/clouddrive