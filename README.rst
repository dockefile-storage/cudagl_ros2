说明
======

.. code-block:: sh

    sudo apt-get install fonts-wqy-zenhei

创建镜像
----------


.. code-block:: sh

    docker rmi   cudagl:ros-galactic

    docker build -t cudagl:ros-galactic .