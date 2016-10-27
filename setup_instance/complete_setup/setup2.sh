#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y python-numpy python-scipy python-nose python-h5py python-skimage python-matplotlib python-pandas python-sklearn python-sympy python-virtualenv
sudo apt-get clean && sudo apt-get autoremove
sudo rm -rf /var/lib/apt/lists/*


sudo apt-get install aptitude gfortran
sudo aptitude update
sudo aptitude install git

sudo -s
dd if=/dev/zero of=/swapfile1 bs=1024 count=524288
chown root:root /swapfile1
chmod 0600 /swapfile1
mkswap /swapfile1
swapon /swapfile1
cat "\n/swapfile1 none swap sw 0 0\n" >> /etc/fstab

exit

#TensorFlow [avoid]
sudo apt-get install python-pip python-dev
sudo pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.8.0-cp27-none-linux_x86_64.whl



#OpenBLAS
git clone https://github.com/xianyi/OpenBLAS.git ~/OpenBLAS
cd ~/OpenBLAS
make FC=gfortran -j $(($(nproc) + 1))
sudo make PREFIX=/usr/local install



#Common Tools
sudo apt-get install -y libfreetype6-dev libpng12-dev libyaml-dev libhdf5-dev
sudo pip install -U matplotlib ipython[all] jupyter pandas scikit-image