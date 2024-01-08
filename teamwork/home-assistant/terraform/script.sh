#!/bin/bash

# Home assistant script

#Updating your System
sudo apt-get update
# sudo apt-get upgrade -y
# sudo apt-get dist-upgrade -y

#Install Dependency’s
sudo apt-get install \
apparmor \
jq \
wget \
curl \
udisks2 \
libglib2.0-bin \
network-manager \
dbus \
systemd-journal-remote -y
#Install The Docker Engine
sudo curl -fsSL get.docker.com | sh

#Install the OS Agent
sudo wget https://github.com/home-assistant/os-agent/releases/download/1.4.1/os-agent_1.4.1_linux_x86_64.deb

sudo dpkg -i os-agent_1.4.1_linux_x86_64.deb

#Run the Home Assistant Install Script 

sudo wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo dpkg -i homeassistant-supervised.deb
