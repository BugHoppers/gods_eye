#!/bin/sh

chmod +x god


PATH=$PATH:$(pwd)
echo "PATH=$PATH:$(pwd)" >> $HOME/.bashrc
