#!/bin/bash
cd ~
pkg 
wget https://proxy.freecdn.workers.dev/?url=https%3A%2F%2Fgithub.com%2FSansui233%2FproxypoolCheck%2Freleases%2Fdownload%2Fv0.3.0%2FproxypoolCheck-linux-armv8-v0.3.0.gz -O proxypoolCheck-linux-armv8-v0.3.0.gz
gunzip proxypoolCheck-linux-armv8-v0.3.0.gz
chmod 775 proxypoolCheck-linux-armv8-v0.3.0
wget https://raw.githubusercontent.com/jth445600/hello-world/master/config.yaml
 ./proxypoolCheck-linux-armv8-v0.3.0 -c config.yaml 


