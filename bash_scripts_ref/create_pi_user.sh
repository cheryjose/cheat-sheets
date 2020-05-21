#! /bin/bash

printf "### create pi user and add to root\n"
useradd -m -p $(openssl passwd -1 password) -g sudo pi
