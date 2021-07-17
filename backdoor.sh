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


stop_firewall()  {
	##  关闭防火墙命令centos
	 systemctl status firewalld.service #（查看防火墙状态）
	systemctl disable firewalld #（停止防火墙开机启动）
	systemctl stop firewalld #（停止防火墙）
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
    red " 2. 安装docker（通用） "
    green " 3. 查看配置参数"
    yellow " 0. Exit"
    echo
    read -p "输入数字:" num
    case "$num" in
    1)
    check_release
    check_port
    check_domain "ws_tls"
    ;;
    
    2)
    remove_xray 
    ;;
    3)
    get_myconfig
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