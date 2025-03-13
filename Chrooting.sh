#!/usr/bin/env bash

printf "${CHROOT_KEYBOARD}"
printf "test"

# Setting keyboard layout
printf sudo loadkeys ${CHROOT_KEYBOARD}

# Making it permanent to the system
sudo echo 'KEYMAP='${CHROOT_KEYBOARD}'' >> /etc/vconsole.conf

# Changing some timeout
sudo sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/user.conf

# Pacman configuration
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sudo sed -i 's/ParallelDownloads = 5/ParallelDownloads = 7/g' /etc/pacman.conf
sudo echo "ILoveCandy" | sudo tee -a /etc/pacman.conf
sudo sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sudo sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlists/g' /etc/pacman.conf


# Installing NetworkManager
sudo pacman -Syu networkmanager


sudo systemctl enable NetworkManager

