#!/usr/bin/env bash

# Making it permanent to the system
printf "KEYMAP=%s\n" "$CHROOT_KEYBOARD" >/etc/vconsole.conf

# Changing some timeout
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/user.conf

# Pacman configuration
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/ParallelDownloads = 5/ParallelDownloads = 7/g' /etc/pacman.conf
echo "ILoveCandy" >> /etc/pacman.conf
sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/g' /etc/pacman.conf

sleep 10s

# Installing NetworkManager
pacman -Syu networkmanager --noconfirm --needed
systemctl enable NetworkManager

#Installing DNS
cat /mnt/home/dn0.txt > /etc/NetworkManager/conf.d/dns-servers.conf
rm /mnt/home/dn0.txt


sleep 50s
