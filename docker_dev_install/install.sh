#!/usr/bin/env bash

SELF_RELATIVE_DIR=`dirname $0`                       # 获取 脚本文件所在的相对路径
SELF_ABSOLUTE_DIR=`readlink -f "$SELF_RELATIVE_DIR"` # 当前 脚本文件，所在的绝对路径
cd $SELF_ABSOLUTE_DIR 

mkdir ~/shared_dir 

mkdir -p ~/.config/autoplot_cfg/
cp -rvf cfg/default.rviz      ~/.config/autoplot_cfg/
cp -rvf cfg/rviz.yaml         ~/.config/autoplot_cfg/
cp -rvf cfg/pm-autopilot-2.0  ~/.config/

mkdir -p ~/.local/docker-2.0/img/

sed -i "s|_HOME_|${HOME}|" desktop/autoplot_cfg_docker.desktop 
sed -i "s|_HOME_|${HOME}|" desktop/autoplot_gui_docker.desktop 
sed -i "s|_HOME_|${HOME}|" desktop/ultr_gui_docker.desktop 
sed -i "s|_HOME_|${HOME}|" desktop/autoplot_gui_quickstart.desktop 

cp -rvf  desktop/*.desktop  ~/Desktop/
cp -rvf  desktop/*.desktop  ~/桌面/
cp -rvf  desktop/*.png  ~/.local/docker-2.0/img/


cp -rvf  bin   ~/.local/docker-2.0/

##
sudo apt-get install fonts-wqy-zenhei
docker pull 192.168.2.100:8086/pm-autopilot/pm-autopilot-dev:2.0.1