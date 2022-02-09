说明
======

.. code-block:: sh

    sudo apt-get install fonts-wqy-zenhei

创建镜像
----------


.. code-block:: sh

    docker rmi   cudagl:ros-melodic

    docker build -t cudagl:ros-melodic .