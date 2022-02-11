说明
======

.. code-block:: sh

    sudo apt-get install fonts-wqy-zenhei

创建镜像
----------


.. code-block:: sh

    docker rmi   cudagl:autowareArchitectureProposal_local

    docker build -t cudagl:autowareArchitectureProposal_local .


.. code-block:: sh

    wget -qO - http://192.168.2.100/pm-autopilot-3.0/docker_architectureproposal/-/raw/AutowareArchitectureProposal_local/docker_dev_install/bin/docker_run_develop.sh | bash

