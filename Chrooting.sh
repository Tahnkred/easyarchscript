#!/usr/bin/env bash

echo "${CHROOT_KEYBOARD}"
echo "test"

# Setting keyboard layout
loadkeys ${CHROOT_KEYBOARD}

# Making it permanent to the system
echo 'KEYMAP='${CHROOT_KEYBOARD}'' >> /etc/vconsole.conf

# Changing some timeout
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/user.conf

# Pacman configuration
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/ParallelDownloads = 5/ParallelDownloads = 7/g' /etc/pacman.conf
echo "ILoveCandy" | sudo tee -a /etc/pacman.conf
sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlists/g' /etc/pacman.conf


# Installing NetworkManager
pacman -Syu networkmanager


systemctl enable NetworkManager

