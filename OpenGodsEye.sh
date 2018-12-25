#!/bin/sh

chmod +x god


echo "export PATH=\$PATH:$(pwd)" >> $HOME/.bashrc
exec bash
