#wget http://bitbucket.org/eigen/eigen/get/3.3.7.tar.gz #Download Eigen 失效
wget -O 3.3.7.tar.gz https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.gz

mkdir eigen && tar --strip-components=1 -xzvf 3.3.7.tar.gz -C eigen #Decompress

cd eigen && mkdir build && cd build && cmake .. && make && sudo make install #Build and install

cd ../../ && rm -rf 3.3.7.tar.gz && rm -rf eigen #Remove downloaded and temporary files