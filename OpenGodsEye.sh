#!/bin/sh

chmod +x god


exec bash
echo "export PATH=\$PATH:$(pwd)" >> $HOME/.bashrc
