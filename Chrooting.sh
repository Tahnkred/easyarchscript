#!/usr/bin/env bash

printf "KEYMAP=%s\n" "$CHROOT_KEYBOARD"

sleep 10s

# Making it permanent to the system
printf "KEYMAP=%s\n" "$CHROOT_KEYBOARD" >/etc/vconsole.conf

sleep 10s

# Changing some timeout
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/user.conf

sleep 10s

# Pacman configuration

sleep 10s

sed -i 's/#Color/Color/g' /etc/pacman.conf

sleep 10s

sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

sleep 10s

sed -i 's/ParallelDownloads = 5/ParallelDownloads = 7/g' /etc/pacman.conf

sleep 10s

echo "ILoveCandy" >> /etc/pacman.conf

sleep 10s

sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf

sleep 10s

sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlists/g' /etc/pacman.conf

sleep 10s
# Installing NetworkManager
pacman -Syu networkmanager --noconfirm --needed

sleep 10s

systemctl enable NetworkManager

sleep 10s

cat ./mnt/home/dn0.conf > /etc/NetworkManager/conf.d/dns-servers.conf

sleep 10s

rm /mnt/home/dn0.conf


sleep 50s
