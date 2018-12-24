#!/bin/sh

chmod +x god
echo $password > config.ge
PATH=$PATH:$(pwd)
