#!/bin/bash

set -e

# Default settings
CUDA="on"
IMAGE_NAME="ros/galactic"
TAG_PREFIX="latest"
ROS_DISTRO="galactic"
BASE_ONLY="false"
PRE_RELEASE="off"
AUTOWARE_HOST_DIR=""
USER_ID="$(id -u)"

function usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "    -b,--base-only <AUTOWARE_HOST_DIR> If provided, run the base image only and mount the provided Autoware folder."
    echo "                                       Default: Use pre-compiled Autoware image"
    echo "    -c,--cuda <on|off>                 Enable Cuda support in the Docker."
    echo "                                       Default: $CUDA"
    echo "    -h,--help                          Display the usage and exit."
    echo "    -i,--image <name>                  Set docker images name."
    echo "                                       Default: $IMAGE_NAME"
    echo "    -p,--pre-release <on|off>          Use pre-release image."
    echo "                                       Default: $PRE_RELEASE"
    echo "    -r,--ros-distro <name>             Set ROS distribution name."
    echo "                                       Default: $ROS_DISTRO"
    echo "    -s,--skip-uid-fix                  Skip uid modification step required when host uid != 1000"
    echo "    -t,--tag-prefix <tag>              Tag prefix use for the docker images."
    echo "                                       Default: $TAG_PREFIX"
}

# Convert a relative directory path to absolute
function abspath() {
    local path=$1
    if [ ! -d $path ]; then
	exit 1
    fi
    pushd $path > /dev/null
    echo $(pwd)
    popd > /dev/null
}


OPTS=`getopt --options b:c:hi:p:r:st: \
         --long base-only:,cuda:,help,image-name:,pre-release:,ros-distro:,skip-uid-fix,tag-prefix: \
         --name "$0" -- "$@"`
eval set -- "$OPTS"

while true; do
  case $1 in
    -b|--base-only)
      BASE_ONLY="true"
      AUTOWARE_HOST_DIR=$(abspath "$2")
      shift 2
      ;;
    -c|--cuda)
      param=$(echo $2 | tr '[:upper:]' '[:lower:]')
      case "${param}" in
        "on"|"off") CUDA="${param}" ;;
        *) echo "Invalid cuda option: $2"; exit 1 ;;
      esac
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -i|--image-name)
      IMAGE_NAME="$2"
      shift 2
      ;;
    -p|--pre-release)
      param=$(echo $2 | tr '[:upper:]' '[:lower:]')
      case "${param}" in
        "on"|"off") PRE_RELEASE="${param}" ;;
        *) echo "Invalid pre-release option: $2"; exit 1 ;;
      esac
      shift 2
      ;;
    -r|--ros-distro)
      ROS_DISTRO="$2"
      shift 2
      ;;
    -s|--skip-uid-fix)
      USER_ID=1000
      shift 1
      ;;
    -t|--tag-prefix)
      TAG_PREFIX="$2"
      shift 2
      ;;
    --)
      if [ ! -z $2 ];
      then
        echo "Invalid parameter: $2"
        exit 1
      fi
      break
      ;;
    *)
      echo "Invalid option"
      exit 1
      ;;
  esac
done

echo "Using options:"
echo -e "\tROS distro: $ROS_DISTRO"
echo -e "\tImage name: $IMAGE_NAME"
echo -e "\tTag prefix: $TAG_PREFIX"
echo -e "\tCuda support: $CUDA"
if [ "$BASE_ONLY" == "true" ]; then
  echo -e "\tAutoware Home: $AUTOWARE_HOST_DIR"
fi
echo -e "\tPre-release version: $PRE_RELEASE"
echo -e "\tUID: <$USER_ID>"

SUFFIX=""
RUNTIME=""

DOCKER_HOME=/home/docker

XSOCK=/tmp/.X11-unix

XAUTH=$HOME/.Xauthority
DOCKER_XAUTH=$DOCKER_HOME/.Xauthority

FONTS=/usr/share/fonts # ????????????

# HOST_CONFIG=$HOME/.config
# DOCKER_CONFIG=$DOCKER_HOME/.config

SHARED_HOST_DIR=$HOME/shared_dir
SHARED_DOCKER_DIR=$DOCKER_HOME/shared_dir

# SHARED_HOST_DIR=$HOME

AUTOWARE_DOCKER_DIR=$DOCKER_HOME/Autoware

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$DOCKER_XAUTH:rw
         --volume=$SHARED_HOST_DIR:$SHARED_DOCKER_DIR:rw
         --volume=$FONTS:$FONTS:rw" # ????????????

        #  --volume=$HOST_CONFIG:$DOCKER_CONFIG:rw

if [ "$BASE_ONLY" == "true" ]; then
    SUFFIX=$SUFFIX"-base"
    VOLUMES="$VOLUMES --volume=$AUTOWARE_HOST_DIR:$AUTOWARE_DOCKER_DIR "
fi

DOCKER_VERSION=$(docker version --format '{{.Client.Version}}' | cut --delimiter=. --fields=1,2)
if [ $CUDA == "on" ]; then
    SUFFIX=$SUFFIX"-cuda"
    if [[ ! $DOCKER_VERSION < "19.03" ]] && ! type nvidia-docker; then
        RUNTIME="--gpus all"
    else
        RUNTIME="--runtime=nvidia"
    fi
fi

if [ $PRE_RELEASE == "on" ]; then
    SUFFIX=$SUFFIX"-rc"
fi

# Create the shared directory in advance to ensure it is owned by the host user
mkdir -p $SHARED_HOST_DIR

#IMAGE=$IMAGE_NAME:$TAG_PREFIX-$ROS_DISTRO$SUFFIX
IMAGE=registry.cn-hangzhou.aliyuncs.com/cudagl/ros2:galactic

echo "Launching $IMAGE"

# docker run \
#    -it --rm \
#    --name="ros-galactic" \
#    $VOLUMES \
#    --env="XAUTHORITY=${XAUTH}" \
#    --env="DISPLAY=${DISPLAY}" \
#    --env="USER_ID=$USER_ID" \
#    --privileged \
#    --net=host \
#    $RUNTIME \
#    ${IMAGE}

docker run \
    -d \
    --name="ros-galactic" \
    $VOLUMES \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --env="USER_ID=$USER_ID" \
    --privileged \
    --net=host \
    --ipc=host \
    $RUNTIME \
    ${IMAGE} \
    /bin/bash  -c  "while true; do echo hello world; sleep 1; done"
    #  /bin/bash -c "/tmp/entrypoint.sh; source /home/autoware/pm-autopilot-2.0.1/devel/setup.bash; source /home/autoware/Autoware/install/setup.bash; roslaunch autopilot_gui start.launch;"

# mkdir -p ${HOME}/.config/autoplot_cfg 
# docker exec -u autoware -w /home/autoware -it pm-autopilot cp /home/autoware/pm-autopilot-2.0.1/src/autopilot_gui/resources/rviz/rviz.yaml  /home/autoware/.config/autoplot_cfg/rviz.yaml

# docker exec pm-autopilot apt-get install ros-melodic-diagnostic-updater
# docker exec pm-autopilot python -m pip install simple-pid==0.2.4
# docker exec pm-autopilot usermod -a -G dialout autoware
# docker exec pm-autopilot chmod a+wrx /dev/ttyS*
# docker exec pm-autopilot apt-get install python-geographiclib python3-geographiclib