
sudo apt-get install libhdf5-dev libyaml-dev pkg-config

pip install future
pip install fabric


git clone https://github.com/NervanaSystems/neon.git
cd neon && sudo make sysinstall

echo -e "\nexport PYTHONPATH=/home/ubuntu/neon/:"$PYTHONPATH >> ~/.bashrc

source ~/.bashrc