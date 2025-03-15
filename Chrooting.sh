#!/usr/bin/env bash

# Making it permanent to the system
printf "KEYMAP=%s\n" "$CHROOT_KEYBOARD" >/etc/vconsole.conf

# Changing some timeout
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/user.conf

# Pacman configuration
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf
sed -i 's/ParallelDownloads = 5/ParallelDownloads = 7/g' /etc/pacman.conf
sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf                                                    #Idk it doesn't work
sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/g' /etc/pacman.conf    #Idk it doesn't work
echo "ILoveCandy" >> /etc/pacman.conf

sleep 5s

# Installing NetworkManager
pacstrap -K /mnt networkmanager --noconfirm --needed
systemctl enable NetworkManager

#Installing DNS
cat ./dn0.txt > /etc/NetworkManager/conf.d/dns-servers.conf
rm ./dn0.txt


sleep 20s
