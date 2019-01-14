#!/bin/sh

chmod +x god

PATH=$PATH:$(pwd)
echo -e "\n# God's Eye Path :" >> $HOME/.bashrc
echo "export PATH=\$PATH:$(pwd)" >> $HOME/.bashrc
source $HOME/.bashrc
pip3 install -r requirements.txt
