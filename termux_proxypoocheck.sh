#!/bin/bash
##
# wget https://raw.githubusercontent.com/jth445600/hello-world/master/termux_proxypoocheck.sh && sh termux_proxypoocheck.sh
##
cd ~

wget https://cdn.jsdelivr.net/gh/jth445600/hello-world@master/proxypoolCheck

chmod 775 proxypoolCheck
wget https://cdn.jsdelivr.net/gh/jth445600/hello-world@master/config.yaml
 ./proxypoolCheck-c config.yaml 



