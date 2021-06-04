#!/bin/bash
##
# wget https://raw.githubusercontent.com/jth445600/hello-world/master/termux_proxypoocheck.sh && sh termux_proxypoocheck.sh
##
cd ~
# sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list

# sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list

# sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list

# pkg update

wget https://cdn.jsdelivr.net/gh/jth445600/hello-world@master/proxypoolCheck

chmod 775 proxypoolCheck
wget https://cdn.jsdelivr.net/gh/jth445600/hello-world@master/config.yaml
 ./proxypoolCheck -c config.yaml 



