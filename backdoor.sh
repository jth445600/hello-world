#!/bin/bash

#使用方法 
#wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/jth445600/hello-world/master/backdoor.sh" && chmod +x install.sh && bash install.sh


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


stop_firewall(){
	##  关闭防火墙命令centos
	systemctl status firewalld.service #（查看防火墙状态）
	systemctl disable firewalld #（停止防火墙开机启动）
	systemctl stop firewalld #（停止防火墙）
}

install_needed_tools(){
	yum update -y
	yum install wget  git -y
}

run_bbr(){
	wget -N --no-check-certificate "https://github.000060000.xyz/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
}

run_docker(){
	curl -fsSL https://get.docker.com | bash
	curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod a+x /usr/local/bin/docker-compose
	rm -f `which dc`
	ln -s /usr/local/bin/docker-compose /usr/bin/dc
	systemctl start docker
	service docker start
	systemctl enable docker.service
	systemctl status docker.service #（出现active (running)表示安装成功）
	echo "（出现active (running)表示安装成功）"
}

run_xray(){

	#yum install git  #  (centos)
	git clone https://github.com/XrayR-project/XrayR-release
	cd XrayR-release
	# dc pull  # 更新xrary
	
}

function start_menu(){
    clear
    green "======================================================="
    echo -e "\033[34m\033[01m描述：\033[0m \033[32m\033[01m后端一键安装脚本一键安装脚本\033[0m"
    echo -e "\033[34m\033[01m描述：\033[0m \033[32m\033[01m测试阶段 v0.1.0\033[0m"
    echo -e "\033[34m\033[01m描述：\033[0m \033[32m\033[01m作者：Laurence666\033[0m"
    echo -e "\033[34m\033[01m系统：\033[0m \033[32m\033[01m仅仅支持centos7\033[0m"
    green "======================================================="
    green " 1. 安装bbr选5(通用)"
    red " 2. 安装docker（通用） （出现active (running)表示安装成功） "
    green " 安装xrary命令（通用）"
    yellow " 0. Exit"
    echo
    read -p "输入数字:" num
    case "$num" in
    1)
    stop_firewall
    install_needed_tools
    run_bbr
    ;;
    
    2)
    run_docker
    ;;
    3)
    run_xray
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "请输入正确的数字"
    sleep 2s
    start_menu
    ;;
    esac
}

start_menu