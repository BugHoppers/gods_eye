#!/bin/sh

chmod +x god


PATH=$PATH:$(pwd)
echo -e "\n# God's Eye Path :" >> $HOME/.bashrc
echo "export PATH=\$PATH:$(pwd)" >> $HOME/.bashrc
