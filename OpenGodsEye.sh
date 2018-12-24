#!/bin/sh

chmod +x god
password=$1
echo $password > config.ge
PATH=$PATH:$(pwd)
