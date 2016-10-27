#!/usr/bin/env bash


#Caffe [avoid]
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get install --no-install-recommends libboost-all-dev
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev

git clone https://github.com/BVLC/caffe.git ~/caffe
cd ~/caffe
cp Makefile.config.example Makefile.config

sed -i 's/# USE_CUDNN := 1/USE_CUDNN := 1/' Makefile.config
sed -i 's/BLAS := atlas/BLAS := open/' Makefile.config

sudo pip install -r python/requirements.txt
make all -j $(($(nproc) + 1))
make test -j $(($(nproc) + 1))
make runtest -j $(($(nproc) + 1))

make pycaffe -j $(($(nproc) + 1))

echo 'export CAFFE_ROOT=$(pwd)' >> ~/.bashrc
echo 'export PYTHONPATH=$CAFFE_ROOT/python:$PYTHONPATH' >> ~/.bashrc
source ~/.bashrc



#Theano
sudo pip install Theano



#Keras
sudo pip install keras


