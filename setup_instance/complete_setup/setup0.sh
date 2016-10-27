#!/usr/bin/env bash

sudo apt-get update  
sudo apt-get upgrade  
sudo apt-get install build-essential cmake g++ gfortran pkg-config software-properties-common wget unzip
sudo apt-get autoremove 
sudo rm -rf /var/lib/apt/lists/*

cd /tmp
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1404*amd64.deb
sudo apt-get update
sudo apt-get install cuda-toolkit-7-5

echo -e "\nexport CUDA_HOME=/usr/local/cuda\nexport CUDA_ROOT=/usr/local/cuda" >> ~/.bashrc
echo -e "\nexport PATH=/usr/local/cuda/bin:\$PATH\nexport LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc

source ~/.bashrc

cat /proc/driver/nvidia/version
nvcc -V

sudo shutdown -r now