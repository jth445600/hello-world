#!/bin/bash
##查找适合自己当前网络环境的优选Cloudflare Anycast IP
#github项目地址: https://github.com/badafans/better-cloudflare-ip
#
#
curl https://proxy.freecdn.workers.dev/?url=https://github.com/badafans/better-cloudflare-ip/releases/latest/download/linux.tar.gz -o linux.tar.gz
tar -zvxf linux.tar.gz
cd linux
./configure
make
cd src
sudo ./cf.sh