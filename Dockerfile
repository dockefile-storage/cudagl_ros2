FROM nvidia/cudagl:11.1.1-devel-ubuntu20.04

LABEL Jiangxumin <cjiangxumin@gmail.com>

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
     ros-galactic-rmw-cyclonedds-cpp \
  && apt-get clean \
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

RUN source /opt/ros/galactic/setup.bash \
  && rosdep init  \
  && rosdep update 

## install cudnn 8.0.5 , TensorRT 7.2.1
RUN curl -sLO  https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb \
 && DEBIAN_FRONTEND=noninteractive apt-get install nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb  \
 && rm nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb \
 && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  \
    libcudnn8=8.0.5.39-1+cuda11.1  \
    libcudnn8-dev=8.0.5.39-1+cuda11.1 \
    libnvinfer7=7.2.1-1+cuda11.1 \
    libnvinfer-dev=7.2.1-1+cuda11.1 \
    libnvinfer-plugin7=7.2.1-1+cuda11.1 \
    libnvinfer-plugin-dev=7.2.1-1+cuda11.1 \
    libnvonnxparsers7=7.2.1-1+cuda11.1 \
    libnvonnxparsers-dev=7.2.1-1+cuda11.1 \
    libnvparsers7=7.2.1-1+cuda11.1 \
    libnvparsers-dev=7.2.1-1+cuda11.1 \
    && apt-mark hold cuda-11-1 \
    libcudnn8 \
    libcudnn8-dev \
    libnvinfer7 \
    libnvinfer-dev \
    libnvinfer-plugin7 \
    libnvinfer-plugin-dev \
    libnvonnxparsers7 \
    libnvonnxparsers-dev \
    libnvparsers7 \
    libnvparsers-dev 

# COPY shell /root/shell  
# RUN  bash  /root/shell/ros_instal.sh
# RUN  bash  /root/shell/eigen_instal.sh
# RUN  bash  /root/shell/depends.sh

USER docker
WORKDIR /home/docker
COPY .bash_aliases  .bash_aliases
CMD /bin/bash