#! /bin/bash

printf "### install packages\n"

printf "#### install python packs\n"
sudo apt-get --assume-yes install python3-pip python3-testresources python3-venv python3-dev gcc
sudo python3 -m pip install --upgrade pip
wait

printf "#### install package dependency for fiona(python package for *.shp files)\n"
sudo apt-get --assume-yes install libgdal-dev
wait 

printf "#### install audio packs\n"
sudo apt-get --assume-yes install alsa-utils libsdl-ttf2.0-0 libsdl-mixer1.2 libasound2-dev
wait

printf "#### install productivity packs\n"
sudo apt-get --assume-yes install jq
wait

printf "#### install snap\n"
sudo apt-get --assume-yes install snapd
wait

printf "#### install mosquitto packs\n"
sudo snap install mosquitto --channel=1.6/stable
sudo apt-get --assume-yes install libgeos-dev mosquitto-clients 
wait
