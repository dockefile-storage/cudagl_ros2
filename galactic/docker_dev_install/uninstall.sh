#!/usr/bin/env bash

SELF_RELATIVE_DIR=`dirname $0`                       # 获取 脚本文件所在的相对路径
SELF_ABSOLUTE_DIR=`readlink -f "$SELF_RELATIVE_DIR"` # 当前 脚本文件，所在的绝对路径
cd $SELF_ABSOLUTE_DIR 


# cp -rvf  desktop/*.png  ~/.local/docker-2.0/img/

rm -rvf ~/.local/docker-2.0/bin
rm -rvf ~/桌面/autoplot_cfg_docker.desktop  
rm -rvf ~/桌面/autoplot_gui_docker.desktop  
rm -rvf ~/桌面/autoplot_gui_quickstart.desktop

rm -rvf ~/Desktop/autoplot_cfg_docker.desktop  
rm -rvf ~/Desktop/autoplot_gui_docker.desktop  
rm -rvf ~/Desktop/ultr_gui_docker.desktop  
rm -rvf ~/Desktop/autoplot_gui_quickstart.desktop

##
#sudo apt-get install fonts-wqy-zenhei
#docker pull 192.168.2.100:8086/pm-autopilot/pm-autopilot-dev:2.0.1