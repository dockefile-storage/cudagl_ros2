IP=127.0.0.1
PORT=7890

export HTTPS_PROXY=http://${IP}:${PORT}
export https_proxy=http://${IP}:${PORT}
export HTTP_PROXY=http://${IP}:${PORT}
export http_proxy=http://${IP}:${PORT}


sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

sudo tee  /etc/apt/sources.list.d/autonomoustuff-public.list <<-'EOF'
deb [trusted=yes] https://s3.amazonaws.com/autonomoustuff-repo/ focal  main
EOF

# for kvaser-linux
sudo tee /etc/apt/sources.list.d/ppa_astuff_kvaser_linux_focal.list <<- 'EOF'
deb http://ppa.launchpad.net/astuff/kvaser-linux/ubuntu focal main
EOF

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6390D5EC6C3076CE

sudo apt-get update 

DEBIAN_FRONTEND=noninteractive

sudo -H pip3 install -U xmlschema
sudo -H apt-get install -y libcrypto++-dev
#sudo -H apt-get install -y ros-galactic-xacro
#sudo -H apt-get install -y ros-galactic-ament-cmake-clang-format
#sudo -H apt-get install -y ros-galactic-can-msgs
sudo -H apt-get install -y libpcap0.8-dev
sudo -H apt-get install -y libgeographic-dev
#sudo -H apt-get install -y ros-galactic-lanelet2-core
#sudo -H apt-get install -y ros-galactic-lanelet2-io
#sudo -H apt-get install -y ros-galactic-lanelet2-maps
#sudo -H apt-get install -y ros-galactic-lanelet2-projection
#sudo -H apt-get install -y ros-galactic-lanelet2-routing
#sudo -H apt-get install -y ros-galactic-lanelet2-traffic-rules
#sudo -H apt-get install -y ros-galactic-lanelet2-validation
sudo -H apt-get install -y libpugixml-dev
sudo -H apt-get install -y libyaml-cpp-dev
sudo -H apt-get install -y libembree-dev
sudo -H apt-get install -y libapr1-dev
sudo -H apt-get install -y libaprutil1-dev
sudo -H apt-get install -y python3-bson
sudo -H apt-get install -y python3-tornado
#sudo -H apt-get install -y ros-galactic-octomap
#sudo -H apt-get install -y ros-galactic-camera-info-manager
#sudo -H apt-get install -y ros-galactic-ros-testing
#sudo -H apt-get install -y ros-galactic-geographic-msgs
sudo -H apt-get install -y libomp-dev
sudo -H apt-get install -y nlohmann-json3-dev
#sudo -H apt-get install -y ros-galactic-rqt-robot-monitor
sudo -H apt-get install -y libfmt-dev
# sudo -H apt-get install -y ros-galactic-nav2-msgs
# sudo -H apt-get install -y ros-galactic-nav2-costmap-2d
# sudo -H apt-get install -y ros-galactic-automotive-navigation-msgs
# sudo -H apt-get install -y ros-galactic-automotive-platform-msgs
sudo -H apt-get install -y libzmq3-dev
sudo -H apt-get install -y libncurses5-dev
#sudo -H apt-get install -y ros-galactic-filters
sudo -H apt-get install -y libgoogle-glog-dev
sudo -H apt-get install -y libasio-dev
#sudo -H apt-get install -y ros-galactic-octomap-msgs
sudo -H apt-get install -y chrony
sudo -H apt-get install -y sysstat
sudo -H apt-get install -y libnl-genl-3-dev
#sudo -H apt-get install -y ros-galactic-gps-msgs
sudo -H apt-get install -y libzmqpp-dev
sudo -H apt-get install -y libprotobuf-dev
sudo -H apt-get install -y libcpprest-dev
#sudo -H apt-get install -y ros-galactic-osqp-vendor
sudo -H apt-get install -y python3-requests
sudo -H apt-get install -y python3-rtree
sudo -H apt-get install -y v4l-utils
sudo -H apt-get install -y ffmpeg
sudo -H apt-get install -y protobuf-compiler
sudo -H apt-get install -y libprotoc-dev
#sudo -H apt-get install -y ros-galactic-ros2-socketcan
sudo -H apt-get install -y python3-pandas
sudo -H apt-get install -y python3-scipy

sudo -H apt-get install -y kvaser-canlib-dev
# sudo -H apt-get install -y ros-galactic-kvaser-interface
# sudo -H apt-get install -y ros-galactic-pacmod3

sudo -H apt-get install -y  vim

###
# cd /home/docker/AutowareArchitectureProposal/ ; colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release || pwd