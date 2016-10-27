#!/usr/bin/env bash

sudo apt-get install graphviz



#Lasagne [avoid]
#git clone https://github.com/Lasagne/Lasagne.git ~/Lasagne
#cd ~/Lasagne
#sudo python setup.py install



#Nolearn [avoid]
#git clone https://github.com/dnouri/nolearn ~/nolearn
#cd ~/nolearn
#sudo pip install -r requirements.txt
#sudo python setup.py install



#Neon
sudo apt-get install python-pip python-virtualenv libhdf5-dev libyaml-dev pkg-config
git clone https://github.com/NervanaSystems/neon.git ~/neon
cd ~/neon && sudo make sysinstall

#H2O [TODO]