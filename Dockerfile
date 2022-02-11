FROM registry.cn-hangzhou.aliyuncs.com/cudagl/ros2:galactic

LABEL Jiangxumin <cjiangxumin@gmail.com>

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER docker
WORKDIR /home/docker


COPY galactic.tgz  .
COPY src.2021-11-06.tgz .

RUN sudo rm -rf /opt/ros/galactic \
&& mkdir -p /opt/ros/ ; sudo tar xzvf  galactic.tgz -C /opt/ros/ \ 
&& mkdir -p /home/docker/AutowareArchitectureProposal; tar xzvf src.2021-11-06.tgz -C /home/docker/AutowareArchitectureProposal/ \
&& rm -rvf *.tgz

# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#   ansible \
#   curl \
#   unzip \
#   git \
#   gnupg \
#   lsb-release \
#   python3-pip \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/*

COPY shell shell  
RUN  bash  shell/AutowareArchitectureProposal_local.sh

CMD /bin/bash