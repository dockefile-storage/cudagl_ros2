#!/usr/bin/env bash 
set -e  # 有错误就退出

apt-get update 
apt-get install -y --allow-downgrades ros-melodic-autoware-can-msgs
apt-get install -y --allow-downgrades ros-melodic-autoware-config-msgs
apt-get install -y --allow-downgrades ros-melodic-autoware-external-msgs 
apt-get install -y --allow-downgrades ros-melodic-autoware-map-msgs
apt-get install -y --allow-downgrades ros-melodic-autoware-msgs
apt-get install -y --allow-downgrades ros-melodic-autoware-system-msgs

#
apt-get install -y --allow-downgrades ros-melodic-jsk-rviz-plugins

apt-get install -y --allow-downgrades ros-melodic-nmea-msgs  \
                                      ros-melodic-costmap-converter \
                                      ros-melodic-can-dbc-parser


apt-get install -y --allow-downgrades  ros-melodic-qt-create \
                                       ros-melodic-qt-build \
                                       qtmultimedia5-dev

# Drivers
apt-get install -y --allow-downgrades ros-melodic-diagnostic-updater ros-melodic-rslidar \
    ros-melodic-serial \
    ros-melodic-turtlesim


############## 
usermod -a -G dialout docker
# chmod a+wrx /dev/ttyS*

apt-get install -y --allow-downgrades python-geographiclib python3-geographiclib
apt-get install -y --allow-downgrades python-pip   libmuparser-dev


apt-get install -y --allow-downgrades python-bloom fakeroot=1.22-2ubuntu1
apt-get clean

python -m pip install simple-pid==0.2.4


python3 -m pip install -r /root/shell/requirements.txt \
                        -i https://mirrors.aliyun.com/pypi/simple/


#################
#autopliot_cfg
#################
# pip3 install --upgrade setuptools && python3 -m pip install --upgrade pip
apt-get install -y --allow-downgrades python3-lxml
 
apt-get install -y --allow-downgrades ros-melodic-can-msgs \
                                      ros-melodic-can-dbc-parser \
                                      ros-melodic-socketcan-bridge 

apt-get install -y --allow-downgrades ros-melodic-rqt-reconfigure

su - docker -c "git config --global user.email \"you@example.com\""
su - docker -c "git config --global user.name you_name"

apt clean