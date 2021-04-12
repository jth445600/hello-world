#!/bin/bash

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

install_pc(){
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 安装爬虫"
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
    wget https://github.com/Sansui233/proxypool/releases/download/v0.6.0/proxypool-linux-amd64-v0.6.0.gz
    gzip -d proxypool-linux-amd64-v0.6.0.gz
    mv proxypool-linux-amd64-v0.6.0 proxypool
    chmod 755 proxypool

    wget https://raw.githubusercontent.com/lanhebe/proxypool/master/config.yaml
    wget https://raw.githubusercontent.com/lanhebe/proxypool/master/source.yaml
   
    cat > ./config.yaml <<-EOF
    domain: $your_domain
    port:                 # default 12580
    # source list file
    source-files:
      # use local file
      - ./source.yaml
      # use web file
      # - https://example.com/config/source.yaml
    # ======= 可选项，留空使用default值  =======
    # postgresql database info
    database_url: ""
    # interval between each crawling
    crawl-interval:       # v0.5.x default 60 (minutes)
    crontime:             # v0.4.x default 60 (minutes). Deprecated in the newest version
    # speed test
    speedtest: false      # default false. Warning: this will consume large network resources.
    speedtest-interval:   # default 720 (min)
    connection:           # default 5. The number of speed test connections simultaneously
    timeout:              # default 10 (seconds).
    ## active proxy speed test
    active-interval:      # default 60 (min)
    active-frequency:     # default 100 (requests per interval)
    active-max-number:    # default 100. If more than this number of active proxies, the extra will be deprecated by speed
    # cloudflare api
    cf_email: ""
    cf_key: ""
EOF
   
    nohup ./proxypool -c config.yaml >/dev/null 2>/dev/null &
    green "=================xray手动配置参数=================="
    cat /usr/local/etc/xray/myconfig.json
    echo
    green "=================xray客户端配置文件=================="
    echo "/usr/local/etc/xray/client.json"
    echo ""
    green "本次成功安装Xray+爬虫！"
}

check_release(){
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 检查系统版本"
    if [ "$RELEASE" == "centos" ]; then
        yum install -y wget
        systemPackage="yum"
        if  [ "$VERSION" == "6" ] ;then
            red "$(date +"%Y-%m-%d %H:%M:%S") - 暂不支持CentOS 6.\n== Install failed."
            exit
        fi
        if  [ "$VERSION" == "5" ] ;then
            red "$(date +"%Y-%m-%d %H:%M:%S") - 暂不支持CentOS 5.\n== Install failed."
            exit
        fi
        if [ -f "/etc/selinux/config" ]; then
            CHECK=$(grep SELINUX= /etc/selinux/config | grep -v "#")
            if [ "$CHECK" == "SELINUX=enforcing" ]; then
                green "$(date +"%Y-%m-%d %H:%M:%S") - SELinux状态非disabled,关闭SELinux."
                setenforce 0
                sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
            elif [ "$CHECK" == "SELINUX=permissive" ]; then
                green "$(date +"%Y-%m-%d %H:%M:%S") - SELinux状态非disabled,关闭SELinux."
                setenforce 0
                sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
            fi
        fi
        firewall_status=`firewall-cmd --state`
        if [ "$firewall_status" == "running" ]; then
            green "$(date +"%Y-%m-%d %H:%M:%S") - FireWalld状态为running,关闭FireWalld."
            #firewall-cmd --zone=public --add-port=80/tcp --permanent
            #firewall-cmd --zone=public --add-port=443/tcp --permanent
            #firewall-cmd --reload
            systemctl disable firewalld
            systemctl stop firewalld
        fi
        #rm -f /var/lib/rpm/.rpm.lock
        while [ ! -f "nginx-release-centos-7-0.el7.ngx.noarch.rpm" ]
        do
            wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
            if [ ! -f "nginx-release-centos-7-0.el7.ngx.noarch.rpm" ]; then
                red "$(date +"%Y-%m-%d %H:%M:%S") - 下载nginx rpm包失败，继续重试..."
            fi
        done
        rpm -ivh nginx-release-centos-7-0.el7.ngx.noarch.rpm --force --nodeps
        #green "Prepare to install nginx."
        #yum install -y libtool perl-core zlib-devel gcc pcre* >/dev/null 2>&1
        yum install -y epel-release
    else
        red "$(date +"%Y-%m-%d %H:%M:%S") - 当前系统不被支持. \n== Install failed."
        exit
    fi
}

check_port(){
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 检查端口"
    echo
    echo
    $systemPackage -y install net-tools
    Port80=`netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 80`
    Port443=`netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 443`
    if [ -n "$Port80" ]; then
        process80=`netstat -tlpn | awk -F '[: ]+' '$5=="80"{print $9}'`
        red "$(date +"%Y-%m-%d %H:%M:%S") - 80端口被占用,占用进程:${process80}\n== Install failed."
        exit 1
    fi
    if [ -n "$Port443" ]; then
        process443=`netstat -tlpn | awk -F '[: ]+' '$5=="443"{print $9}'`
        red "$(date +"%Y-%m-%d %H:%M:%S") - 443端口被占用,占用进程:${process443}.\n== Install failed."
        exit 1
    fi
}
install_nginx(){
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 安装nginx"
    echo
    echo
    $systemPackage install -y nginx
    if [ ! -d "/etc/nginx" ]; then
        red "$(date +"%Y-%m-%d %H:%M:%S") - 看起来nginx没有安装成功，请先使用脚本中的删除xray功能，然后再重新安装.\n== Install failed."
        exit 1
    fi
    
cat > /etc/nginx/nginx.conf <<-EOF
user  root;
worker_processes  1;
#error_log  /etc/nginx/error.log warn;
#pid    /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
    #access_log  /etc/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  120;
    client_max_body_size 20m;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
}
EOF

cat > /etc/nginx/conf.d/default.conf<<-EOF    
server { 
    listen       0.0.0.0:80;
    server_name  $your_domain;
    root /usr/share/nginx/html/;
    index index.php index.html;
    #rewrite ^(.*)$  https://\$host\$1 permanent; 
}
EOF
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 检测nginx配置文件"
    nginx -t
    systemctl enable nginx.service
    systemctl restart nginx.service
    green "$(date +"%Y-%m-%d %H:%M:%S") - 使用acme.sh申请https证书."
    curl https://get.acme.sh | sh
    ~/.acme.sh/acme.sh  --issue  -d $your_domain  --webroot /usr/share/nginx/html/
    if test -s /root/.acme.sh/$your_domain/fullchain.cer; then
        green "$(date +"%Y-%m-%d %H:%M:%S") - 申请https证书成功."
    else
        cert_failed="1"
        red "$(date +"%Y-%m-%d %H:%M:%S") - 申请证书失败，请尝试手动申请证书."
    fi
cat > /etc/nginx/conf.d/default.conf<<-EOF
server {
    listen       0.0.0.0:80;
    server_name  $your_domain;
    return 301 https://$your_domain\$request_uri;
}

server {
    listen       127.0.0.1:37212 http2;
    server_name  $your_domain;
    root /usr/share/nginx/html;
    index index.php index.html;
    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    location / {
       proxy_pass http://127.0.0.1:12580/;
    }
}
EOF
    nginx -s reload
    install_xray
    install_pc
}

install_xray(){ 
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 安装xray"
    echo
    echo
    mkdir /usr/local/etc/xray/
    mkdir /usr/local/etc/xray/cert
    bash <(curl -L https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)
    cd /usr/local/etc/xray/
    rm -f config.json
    v2uuid=$(cat /proc/sys/kernel/random/uuid)
cat > /usr/local/etc/xray/config.json<<-EOF
{
    "log": {
        "loglevel": "warning"
    }, 
    "inbounds": [
        {
            "listen": "0.0.0.0", 
            "port": 443, 
            "protocol": "vless", 
            "settings": {
                "clients": [
                    {
                        "id": "$v2uuid", 
                        "level": 0, 
                        "email": "a@b.com",
                        "flow":"xtls-rprx-direct"
                    }
                ], 
                "decryption": "none", 
                "fallbacks": [
                    {
                        "alpn": "h2", 
                        "dest": 37212
                    }
                ]
            }, 
            "streamSettings": {
                "network": "tcp", 
                "security": "xtls", 
                "xtlsSettings": {
                    "serverName": "$your_domain", 
                    "alpn": [
                        "h2", 
                        "http/1.1"
                    ], 
                    "certificates": [
                        {
                            "certificateFile": "/usr/local/etc/xray/cert/fullchain.cer", 
                            "keyFile": "/usr/local/etc/xray/cert/private.key"
                        }
                    ]
                }
            }
        }
    ], 
    "outbounds": [
        {
            "protocol": "freedom", 
            "settings": { }
        }
    ]
}
EOF
cat > /usr/local/etc/xray/client.json<<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 1080,
            "listen": "127.0.0.1",
            "protocol": "socks",
            "settings": {
                "udp": true
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "vless",
            "settings": {
                "vnext": [
                    {
                        "address": "$your_domain",
                        "port": 443,
                        "users": [
                            {
                                "id": "$v2uuid",
                                "flow": "xtls-rprx-direct",
                                "encryption": "none",
                                "level": 0
                            }
                        ]
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "serverName": "$your_domain"
                }
            }
        }
    ]
}
EOF
    if [ -d "/usr/share/nginx/html/" ]; then
        cd /usr/share/nginx/html/ && rm -f ./*
    fi
    systemctl enable xray.service
    sed -i "s/User=nobody/User=root/;" /etc/systemd/system/xray.service
    systemctl daemon-reload
    ~/.acme.sh/acme.sh  --installcert  -d  $your_domain   \
        --key-file   /usr/local/etc/xray/cert/private.key \
        --fullchain-file  /usr/local/etc/xray/cert/fullchain.cer \
        --reloadcmd  "chmod -R 777 /usr/local/etc/xray/cert && systemctl restart xray.service"

cat > /usr/local/etc/xray/myconfig.json<<-EOF
{
地址：${your_domain}
端口：443
id：${v2uuid}
加密：none
流控：xtls-rprx-origin
别名：自定义
传输协议：tcp
伪装类型：none
底层传输：xtls
跳过证书验证：false
}
EOF

    green "== xray安装完成."
}

check_domain(){
    $systemPackage install -y wget curl unzip
    blue "请键入解析到本机VPS IP的域名:"
    read your_domain
    real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
    local_addr=`curl ipv4.icanhazip.com`
    if [ $real_addr == $local_addr ] ; then
        green "域名解析地址与VPS IP地址匹配."
        install_nginx
    else
        red "域名解析地址与VPS IP地址不匹配."
        read -p "强制安装?请输入 [Y/n] :" yn
        [ -z "${yn}" ] && yn="y"
        if [[ $yn == [Yy] ]]; then
            sleep 1s
            install_nginx
        else
            exit 1
        fi
    fi
}

remove_xray(){
    green "$(date +"%Y-%m-%d %H:%M:%S") - 删除xray."
    systemctl stop xray.service
    systemctl disable xray.service
    systemctl stop nginx
    systemctl disable nginx
    if [ "$RELEASE" == "centos" ]; then
        yum remove -y nginx
    else
        apt-get -y autoremove nginx
        apt-get -y --purge remove nginx
        apt-get -y autoremove && apt-get -y autoclean
        find / | grep nginx | sudo xargs rm -rf
    fi
    pkill proxypool
    rm -rf /usr/local/share/xray/ /usr/local/etc/xray/
    rm -f /usr/local/bin/xray /usr/local/bin/v2ctl 
    rm -rf /etc/systemd/system/xray*
    rm -rf /etc/nginx
    rm -rf /usr/share/nginx/html/*
    rm -rf /root/.acme.sh/
    rm -rf ~/proxypool
    rm -rf ~/config.yaml
    rm -rf ~/source.yaml
    green "=========="
    green " 卸载完成"
    green "=========="
    green "nginx & xray has been deleted."
    
}

function start_menu(){
    clear
    green " ======================================================"
    green " 描述：xray + 免费节点爬虫一键安装脚本"
    green " 系统：仅支持centos7"
    green " 作者：Littleyu+部分代码源于atrandys  www.yugogo.xyz"
    green " YouTuBe频道：Littleyu科学上网"
    green " ======================================================"
    echo
    green " 1. 安装 xray + 免费节点爬虫"
    green " 2. 更新 xray"
    red " 3. 删除 xray + 免费节点爬虫"
    yellow " 0. Exit"
    echo
    read -p "输入数字:" num
    case "$num" in
    1)
    check_release
    check_port
    check_domain
    ;;
    2)
    bash <(curl -L https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)
    systemctl restart xray
    ;;
    3)
    remove_xray 
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "Enter a correct number"
    sleep 2s
    start_menu
    ;;
    esac
}

start_menu