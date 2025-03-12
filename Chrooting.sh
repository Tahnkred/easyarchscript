#!/usr/bin/env bash

# Setting keyboard layout
loadkeys ${KEYBOARD}

sleep 5s

# Making it permanent to the system
echo 'KEYMAP='${KEYBOARD}'' >> /etc/vconsole.conf

sleep 5s

# Changing some timeout
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/user.conf

sleep 5s

# Pacman configuration
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/ParallelDownloads = 5/ParallelDownloads = 7/g' /etc/pacman.conf
echo "ILoveCandy" | sudo tee -a /etc/pacman.conf
sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlists/g' /etc/pacman.conf

sleep 5s

# Installing NetworkManager
pacman -Syu networkmanager

sleep 5s

systemctl enable NetworkManager

sleep 5s
