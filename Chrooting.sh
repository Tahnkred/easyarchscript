#!/usr/bin/env bash

printf "KEYMAP=%s\n" "$CHROOT_KEYBOARD"

printf "KEYMAP=%s\n" "$CHROOT_KEYBOARD" >/etc/vconsole.conf

# Making it permanent to the system
printf "KEYMAP=%s\n" "$CHROOT_KEYBOARD" >/etc/vconsole.conf

# Changing some timeout
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/user.conf

# Pacman configuration
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/ParallelDownloads = 5/ParallelDownloads = 7/g' /etc/pacman.conf
printf "ILoveCandy" | sudo tee -a /etc/pacman.conf --noconfirm --needed
sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlists/g' /etc/pacman.conf


# Installing NetworkManager
pacman -Syu networkmanager
systemctl enable NetworkManager

