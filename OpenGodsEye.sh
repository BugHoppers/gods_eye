#!/bin/sh

chmod +x god


PATH=$PATH:$(pwd)
echo "export PATH=\$PATH:$(pwd)" >> $HOME/.bashrc
