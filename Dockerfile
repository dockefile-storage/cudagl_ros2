FROM nvidia/cudagl:11.1.1-devel-ubuntu20.04

LABEL Jiangxumin <cjiangxumin@gmail.com>


## Install APT packages
# hadolint ignore=DL3008
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ansible \
  curl \
  git \
  gnupg \
  lsb-release \
  python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Install vcstool
# hadolint ignore=DL3008
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
  && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3-vcstool \
     gnupg2 \
     libpython3-dev \
     python3-pip \
     python3-rosdep \ 
     ros-galactic-desktop \
  &   & apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# sudo apt update && sudo apt install curl gnupg lsb-release
# sudo rosdep init
# rosdep update


## Setup build environment in a temporary directory
# hadolint ignore=DL3003
# RUN --mount=type=ssh \
#   mkdir -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts \
#   && git clone git@github.com:tier4/autoware.proj.git -b main /tmp/autoware.proj \
#   && cd /tmp/autoware.proj \
#   && mkdir src \
#   && vcs import src < autoware.proj.repos \
#   && ./setup_ubuntu20.04.sh -c \
#   && rm -rf /tmp/autoware.proj \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/*


USER    root
WORKDIR /root

# RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list &&\
#     sh -c '. /etc/lsb-release && echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu/ $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/ros-latest.list' && \
#     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654 &&\
#     apt-get update

#RUN apt-get install wget

##  add user
RUN apt-get update && \
      apt-get -y install sudo && \
	  DEBIAN_FRONTEND=noninteractive apt install -y tzdata

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN echo "docker ALL=(ALL) NOPASSWD : ALL" > /etc/sudoers.d/nopasswd4sudo 

# COPY shell /root/shell  
# RUN  bash  /root/shell/ros_instal.sh
# RUN  bash  /root/shell/eigen_instal.sh
# RUN  bash  /root/shell/depends.sh

USER docker
WORKDIR /home/docker
CMD /bin/bash

#EXPOSE 22
# CMD ["/root/run.sh"]