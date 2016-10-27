#!/usr/bin/env bash
# Installation script for Cuda and drivers on Ubuntu 14.04, by Roelof Pieters (@graphific)
# BSD License
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

# started with a bare ubuntu 14.04.3 LTS install, with only ubuntu-desktop installed
# script will install the bare minimum, with all "extras" in a seperate venv

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get install -y git wget linux-image-generic build-essential unzip


# manual driver install with:
# sudo service lightdm stop
# (login on non graphical terminal)
# wget http://uk.download.nvidia.com/XFree86/Linux-x86_64/352.30/NVIDIA-Linux-x86_64-352.30.run
# chmod +x ./NVIDIA-Linux-x86_64-352.30.run
# sudo ./NVIDIA-Linux-x86_64-352.30.run

# Cuda 7.0
# instead we install the nvidia driver 352 from the cuda repo
# which makes it easier than stopping lightdm and installing in terminal
cd /tmp
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.0-28_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1404_7.0-28_amd64.deb

echo -e "\nexport CUDA_HOME=/usr/local/cuda\nexport CUDA_ROOT=/usr/local/cuda" >> ~/.bashrc
echo -e "\nexport PATH=/usr/local/cuda/bin:\$PATH\nexport LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc

echo "CUDA installation complete: please reboot your machine and continue with script #2"
