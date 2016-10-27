#!/usr/bin/env bash


#Torch [CHECK!!!]
git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch; bash install-deps;
./install.sh

luarocks install nn && \
	luarocks install cutorch && \
	luarocks install cunn && \
	\
	cd /root && git clone https://github.com/soumith/cudnn.torch.git && cd cudnn.torch && \
	git checkout R4 && \
	luarocks make && \
	\
	cd /root && git clone https://github.com/facebook/iTorch.git && \
	cd iTorch && \
	luarocks make

#Qt dependency
sudo apt-get install -y qt4-dev-tools libqt4-dev libqt4-core libqt4-gui

#Main luarocks libs:
luarocks install image    # an image library for Torch7
luarocks install nnx      # lots of extra neural-net modules
luarocks install unup