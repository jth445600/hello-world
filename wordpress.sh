#!/bin/bash

#脚本使用
# 
#   wget -N --no-check-certificate -q -O wordpress.sh "https://raw.githubusercontent.com/jth445600/hello-world/master/wordpress.sh" && chmod +x wordpress.sh && bash wordpress.sh
#
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
source /etc/os-release
RELEASE=$ID
VERSION=$VERSION_ID

green "== Time  : $(date +"%Y-%m-%d %H:%M:%S")"
green "== OS    : $RELEASE $VERSION"
green "== Kernel: $(uname -r)"
green "== User  : $(whoami)"
sleep 2s

install_wordpress(){
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 安装wordpress"
    yum install -y iptables-services
    systemctl start iptables
    systemctl enable iptables
    iptables -F
    SSH_PORT=$(awk '$1=="Port" {print $2}' /etc/ssh/sshd_config)
    if [ ! -n "$SSH_PORT" ]; then
        iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
    else
        iptables -A INPUT -p tcp -m tcp --dport ${SSH_PORT} -j ACCEPT
    fi
    iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
    iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -i lo -j ACCEPT
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
    service iptables save
    green "====================================================================="
    green "安全起见，iptables仅开启ssh,http,https端口，如需开放其他端口请自行放行"
    green "====================================================================="
    echo
    echo
    sleep 1
    yum -y install  wget
    mkdir /usr/share/wordpresstemp
    cd /usr/share/wordpresstemp/
    wget https://cn.wordpress.org/latest-zh_CN.zip
    if [ ! -f "/usr/share/wordpresstemp/latest-zh_CN.zip" ]; then
        red "从cn官网下载wordpress失败，尝试从github下载……"
        wget https://github.com/atrandys/wordpress/raw/master/latest-zh_CN.zip
    fi
    if [ ! -f "/usr/share/wordpresstemp/latest-zh_CN.zip" ]; then
        red "从github下载wordpress也失败了，请尝试手动安装……"
        green "从wordpress官网下载包然后命名为latest-zh_CN.zip，新建目录/usr/share/wordpresstemp/，上传到此目录下即可"
        exit 1
    fi
    green "==============="
    green " 1.安装必要软件"
    green "==============="
    sleep 1s
    echo
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    if [ -f "epel-release-latest-7.noarch.rpm" -a -f "remi-release-7.rpm" ]; then
        green "下载软件源成功"
    else
        red "下载软件源失败，退出安装"
        exit 1
    fi
    rpm -ivh remi-release-7.rpm epel-release-latest-7.noarch.rpm --force --nodeps
    #sed -i "0,/enabled=0/s//enabled=1/" /etc/yum.repos.d/epel.repo
    yum -y install unzip vim tcl expect curl socat
    echo
    echo
    green "============"
    green "2.安装PHP7.4"
    green "============"
    sleep 1
    yum -y install php74 php74-php-gd php74-php-opcache php74-php-pdo php74-php-mbstring php74-php-cli php74-php-fpm php74-php-mysqlnd php74-php-xml
    service php74-php-fpm start
    chkconfig php74-php-fpm on
    if [ `yum list installed | grep php74 | wc -l` -ne 0 ]; then
        echo
        green "【checked】 PHP7安装成功"
        echo
        echo
        sleep 2s
        php_status=1
    fi
    green "==============="
    green "  3.安装MySQL"
    green "==============="
    sleep 1s
    #wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
    wget https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
    rpm -ivh mysql80-community-release-el7-3.noarch.rpm --force --nodeps
    yum -y install mysql-server
    systemctl enable mysqld.service
    systemctl start  mysqld.service
    if [ `yum list installed | grep mysql-community | wc -l` -ne 0 ]; then
        green "【checked】 MySQL安装成功"
        echo
        echo
        sleep 2
        mysql_status=1
    fi
    echo
    echo
    green "==============="
    green "  4.配置MySQL"
    green "==============="
    sleep 2
    originpasswd=`cat /var/log/mysqld.log | grep password | head -1 | rev  | cut -d ' ' -f 1 | rev`
    mysqlpasswd=`mkpasswd -l 18 -d 2 -c 3 -C 4 -s 5 | sed $'s/[\'\/\;\"\:\.\?\&]//g'`
cat > ~/.my.cnf <<EOT
[mysql]
user=root
password="$originpasswd"
EOT
    mysql  --connect-expired-password  -e "alter user 'root'@'localhost' identified by '$mysqlpasswd';"
    systemctl restart mysqld
    sleep 5s
cat > ~/.my.cnf <<EOT
[mysql]
user=root
password="$mysqlpasswd"
EOT
    mysql  --connect-expired-password  -e "create database wordpress_db;"
    echo
    green "===================="
    green " 5.配置php和php-fpm"
    green "===================="
    echo
    echo
    sleep 1s
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/;" /etc/opt/remi/php74/php.ini
    sed -i "s/pm.start_servers = 5/pm.start_servers = 3/;s/pm.min_spare_servers = 5/pm.min_spare_servers = 3/;s/pm.max_spare_servers = 35/pm.max_spare_servers = 8/;" /etc/opt/remi/php74/php-fpm.d/www.conf
    systemctl restart php74-php-fpm.service
    systemctl restart nginx.service
    green "===================="
    green "  6.安装wordpress"
    green "===================="
    echo
    echo
    sleep 1s
    mkdir /usr/share/nginx
    mkdir /usr/share/nginx/html
    cd /usr/share/nginx/html
    mv /usr/share/wordpresstemp/latest-zh_CN.zip ./
    unzip latest-zh_CN.zip
    mv wordpress/* ./
    #cp wp-config-sample.php wp-config.php
    wget https://raw.githubusercontent.com/atrandys/trojan/master/wp-config.php
    green "===================="
    green "  7.配置wordpress"
    green "===================="
    echo
    echo
    sleep 1
    sed -i "s/database_name_here/wordpress_db/;s/username_here/root/;s?password_here?$mysqlpasswd?;" /usr/share/nginx/html/wp-config.php
    #echo "define('FS_METHOD', "direct");" >> /usr/share/nginx/html/wp-config.php
    chown -R apache:apache /usr/share/nginx/html/
    #chmod 775 apache:apache /usr/share/nginx/html/ -Rf
    chmod -R 755 /usr/share/nginx/html/wp-content
    green "=========================================================================="
    green " WordPress服务端配置已完成，请打开浏览器访问您的域名进行前台配置"
    green " 数据库密码等信息参考文件：/usr/share/nginx/html/wp-config.php"
    green "=========================================================================="
    green "本次安装检测信息如下："
    ps -aux | grep -e nginx -e xray -e mysql -e php
}
