#!/usr/bin/env bash
# Installation script for Deep Learning Libraries on Ubuntu 14.04, by Roelof Pieters (@graphific)
# BSD License

orig_executor="$(whoami)"
if [ "$(whoami)" == "root" ]; then
  echo "running as root, please run as user you want to have stuff installed as"
  exit 1
fi
###################################
#   Ubuntu 14.04 Install script for:
# - Nvidia graphic drivers for Titan X: 352
# - Cuda 7.0 (7.5 gives "out of memory" issues)
# - CuDNN3
# - Theano (bleeding edge)
# - Torch7
# - ipython notebook (running as service with circus auto(re)boot on port 8888)
# - itorch notebook (running as service with circus auto(re)boot on port 8889)
# - Caffe 
# - OpenCV 3.0 gold release (vs. 2015-06-04)
# - Digits
# - Lasagne
# - Nolearn
# - Keras
###################################

export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y libncurses-dev

# next part copied from (check there for newest version): 
# https://github.com/deeplearningparis/dl-machine/blob/master/scripts/install-deeplearning-libraries.sh

####################################
# Dependencies
####################################

# Build latest stable release of OpenBLAS without OPENMP to make it possible
# to use Python multiprocessing and forks without crash
# The torch install script will install OpenBLAS with OPENMP enabled in
# /opt/OpenBLAS so we need to install the OpenBLAS used by Python in a
# distinct folder.
# Note: the master branch only has the release tags in it
sudo apt-get install -y gfortran
export OPENBLAS_ROOT=/opt/OpenBLAS-no-openmp
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OPENBLAS_ROOT/lib
if [ ! -d "OpenBLAS" ]; then
    git clone -q --branch=master git://github.com/xianyi/OpenBLAS.git
    (cd OpenBLAS \
      && make FC=gfortran USE_OPENMP=0 NO_AFFINITY=1 NUM_THREADS=$(nproc) \
      && sudo make install PREFIX=$OPENBLAS_ROOT)
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> ~/.bashrc
fi
sudo ldconfig

# Python basics: update pip and setup a virtualenv to avoid mixing packages
# installed from source with system packages
sudo apt-get update -y 
sudo apt-get install -y python-dev python-pip htop
sudo pip install -U pip virtualenv
if [ ! -d "venv" ]; then
    virtualenv venv
    echo "source ~/venv/bin/activate" >> ~/.bashrc
fi
source venv/bin/activate
pip install -U pip
pip install -U circus circus-web Cython Pillow

cd
sudo apt-get install libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk
pip uninstall pillow
git clone https://github.com/python-pillow/Pillow.git
cd Pillow 
python setup.py install

# Checkout this project to access installation script and additional resources
if [ ! -d "dl-machine" ]; then
    git clone git@github.com:deeplearningparis/dl-machine.git
    (cd dl-machine && git remote add http https://github.com/deeplearningparis/dl-machine.git)
else
    if  [ "$1" == "reset" ]; then
        (cd dl-machine && git reset --hard && git checkout master && git pull --rebase $REMOTE master)
    fi
fi

# Build numpy from source against OpenBLAS
# You might need to install liblapack-dev package as well
sudo apt-get install -y liblapack-dev
rm -f ~/.numpy-site.cfg
ln -s dl-machine/numpy-site.cfg ~/.numpy-site.cfg
pip install -U numpy

# Build scipy from source against OpenBLAS
rm -f ~/.scipy-site.cfg
ln -s dl-machine/scipy-site.cfg ~/.scipy-site.cfg
pip install -U scipy

# Install common tools from the scipy stack
sudo apt-get install -y libfreetype6-dev libpng12-dev
pip install -U matplotlib ipython[all] pandas scikit-image


# Scikit-learn (generic machine learning utilities)
pip install -e git+git://github.com/scikit-learn/scikit-learn.git#egg=scikit-learn

####################################
# OPENCV 3
####################################
# from http://rodrigoberriel.com/2014/10/installing-opencv-3-0-0-on-ubuntu-14-04/
# for 2.9 see http://www.samontab.com/web/2014/06/installing-opencv-2-4-9-in-ubuntu-14-04-lts/ 
cd ~/
sudo apt-get -y install libopencv-dev build-essential cmake git libgtk2.0-dev \
   pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev \
   libpng12-dev libtiff4-dev libjasper-dev libavcodec-dev libavformat-dev \
   libswscale-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev \
   libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev \
   libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip

wget https://github.com/Itseez/opencv/archive/3.0.0.tar.gz -O opencv-3.0.0.tar.gz
tar -zxvf  opencv-3.0.0.tar.gz

cd opencv-3.0.0
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
make -j $(nproc)
sudo make install

sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
ln -s /usr/lib/python2.7/dist-packages/cv2.so /home/$orig_executor/venv/lib/python2.7/site-packages/cv2.so

echo "opencv 3.0 installed"

####################################
# Theano
####################################
# installing theano
# By default, Theano will detect if it can use cuDNN. If so, it will use it. 
# To get an error if Theano can not use cuDNN, use this Theano flag: optimizer_including=cudnn.

pip install -e git+git://github.com/Theano/Theano.git#egg=Theano
if [ ! -f ".theanorc" ]; then
    ln -s ~/dl-machine/theanorc ~/.theanorc
fi

echo "Installed Theano"

# Tutorial files
if [ ! -d "DL4H" ]; then
    git clone git@github.com:SnippyHolloW/DL4H.git
    (cd DL4H && git remote add http https://github.com/SnippyHolloW/DL4H.git)
else
    if  [ "$1" == "reset" ]; then
        (cd DL4H && git reset --hard && git checkout master && git pull --rebase $REMOTE master)
    fi
fi

####################################
# Torch
####################################

if [ ! -d "torch" ]; then
    curl -sk https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
    git clone https://github.com/torch/distro.git ~/torch --recursive
    (cd ~/torch && yes | ./install.sh)
fi
. ~/torch/install/bin/torch-activate

if [ ! -d "iTorch" ]; then
    git clone git@github.com:facebook/iTorch.git
    (cd iTorch && git remote add http https://github.com/facebook/iTorch.git)
else
    if  [ "$1" == "reset" ]; then
        (cd iTorch && git reset --hard && git checkout master && git pull --rebase $REMOTE master)
    fi
fi
(cd iTorch && luarocks make)

cd ~/
git clone https://github.com/torch/demos.git torch-demos

#qt dependency
sudo apt-get install -y qt4-dev-tools libqt4-dev libqt4-core libqt4-gui

#main luarocks libs:
luarocks install image    # an image library for Torch7
luarocks install nnx      # lots of extra neural-net modules
luarocks install unup

echo "Installed Torch (demos in $HOME/torch-demos)"

# Register the circus daemon with Upstart
if [ ! -f "/etc/init/circus.conf" ]; then
    sudo ln -s $HOME/dl-machine/circus.conf /etc/init/circus.conf
    sudo initctl reload-configuration
fi
sudo service circus restart

cd ~/

## Next part ...
####################################
# Caffe
####################################

sudo apt-get install -y libprotobuf-dev libleveldb-dev \
  libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev \
  libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler \
  libatlas-base-dev libyaml-dev 
  
git clone https://github.com/BVLC/caffe.git
cd caffe
for req in $(cat python/requirements.txt); do pip install $req -U; done

make all
make pycaffe

cd python
pip install networkx -U
pip install pillow -U
pip install -r requirements.txt

ln -s ~/caffe/python/caffe ~/venv/lib/python2.7/site-packages/caffe
echo -e "\nexport CAFFE_HOME=/home/$orig_executor/caffe" >> ~/.bashrc

echo "Installed Caffe"

####################################
# Digits
####################################

# Nvidia Digits needs a specific version of caffe
# so you can install the venv version by Nvidia uif you register
# with cudnn, cuda, and caffe already packaged
# instead we will install from scratch
cd ~/

git clone https://github.com/NVIDIA/DIGITS.git digits

cd digits
pip install -r requirements.txt

sudo apt-get install graphviz

echo "digits installed, run with ./digits-devserver or 	./digits-server"

####################################
# Lasagne
# https://github.com/Lasagne/Lasagne
####################################
git clone https://github.com/Lasagne/Lasagne.git
cd Lasagne
python setup.py install

echo "Lasagne installed"

####################################
# Nolearn
# asbtractions, mainly around Lasagne
# https://github.com/dnouri/nolearn
####################################
git clone https://github.com/dnouri/nolearn
cd nolearn
pip install -r requirements.txt
python setup.py install

echo "nolearn wrapper installed"

####################################
# Keras
# https://github.com/fchollet/keras
# http://keras.io/
####################################
git clone https://github.com/fchollet/keras.git
cd keras
python setup.py install

echo "Keras installed"

echo "all done, please restart your machine..."

#   possible issues & fixes:
# - skimage: issue with "not finding jpeg decoder?" 
# "PIL: IOError: decoder zip not available"
# (https://github.com/python-pillow/Pillow/issues/174)
# sudo apt-get install libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk
# next try:
# pip uninstall pillow
# git clone https://github.com/python-pillow/Pillow.git
# cd Pillow 
# python setup.py install
