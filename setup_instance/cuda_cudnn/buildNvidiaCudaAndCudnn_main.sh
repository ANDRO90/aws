#!/bin/bash

set -e

if [ ! -f /tmp/cudnn.tgz ] && [ ! -f /tmp/cudnn.tar ]; then
    echo "ERROR: Installation aborting as cudnn libraries not present. Please download the cudnn library v5.1 from https://developer.nvidia.com/cudnn. to /tmp."
    echo "After download please run the following command :"
    echo "mv /tmp/<YOUR_CUDNN_LIBRARY>.tgz /tmp/cudnn.tgz"
    echo "For example :: mv /tmp/cudnn-7.5-linux-x64-v5.1.tgz /tmp/cudnn.tgz"
    echo "If your downloaded file is a tar file, run the following command :"
    echo "mv /tmp/<YOUR_CUDNN_LIBRARY>.tar /tmp/cudnn.tar"
    echo "For example :: mv /tmp/cudnn-7.5-linux-x64-v5.1.tar /tmp/cudnn.tar"
    exit 1
fi

echo "This script will run for a few minutes. Please wait....... "
sleep 5

echo "*****************************************************************"
echo "Downloading CUDA"
echo "*****************************************************************"

wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run -O /tmp/cuda_7.5.18_linux.run || exit 1

echo "*****************************************************************"
echo "Downloading Nvidia Drivers"
echo "*****************************************************************"

wget http://us.download.nvidia.com/XFree86/Linux-x86_64/352.99/NVIDIA-Linux-x86_64-352.99.run -O /tmp/NVIDIA-Linux-x86_64-352.99.run || exit 1

echo "*****************************************************************"
echo "Installing NVidia Driver, CUDA, and CUDNN"
echo "*****************************************************************"

sudo yum install -y libvdpau

sudo sh /tmp/NVIDIA-Linux-x86_64-352.99.run --silent 2>&1

sleep 1

sudo dkms install nvidia/352.99

sleep 1

sudo nvidia-modprobe

# DO IT TWICE TO MAKE THE DRIVER LOAD
#sudo /tmp/NVIDIA-Linux-x86_64-352.93.run --silent --dkms

cd /usr/local

sudo sh /tmp/cuda_7.5.18_linux.run --silent

if [ -f /tmp/cudnn.tgz ]; then
    sudo tar xfvz /tmp/cudnn.tgz
fi

if [ -f /tmp/cudnn.tar ]; then
    sudo tar -xvf /tmp/cudnn.tar
fi

sudo sh /tmp/NVIDIA-Linux-x86_64-352.99.run --silent 2>&1
sleep 5

nvidia-smi

sudo nvidia-smi -pm 1
