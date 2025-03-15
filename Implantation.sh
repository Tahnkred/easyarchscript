#!/usr/bin/env bash

# Enabling NTP synchronization
timedatectl set-timezone "${TIMEZONE}"
timedatectl set-ntp true

# Creating the GPT partition table
parted --script ${DISK} mklabel gpt

# Creating the EFI and ROOT partitions
echo -e ',512M,L\n,,L' | sfdisk ${DISK} -f

# Creating variables for disk type names: NVMe or HDD/SSD
if [[ ${DISK} =~ ^/dev/sd[a-z]$ ]]
    then EFI="${DISK}1"
         ROOT="${DISK}2"
    echo -e "\e[32mThe EFI partition has been created on ${EFI}.\e[0m"
    echo
    echo -e "\e[32mThe ROOT partition has been created on ${ROOT}.\e[0m"
elif [[ ${DISK} =~ ^/dev/nvme[0-9]+n1$ ]];
    then EFI="${DISK}p1"
         ROOT="${DISK}p2"
    echo -e "\e[32mThe EFI partition has been created on ${EFI}.\e[0m"
    echo
    echo -e "\e[32mThe ROOT partition has been created on ${ROOT}.\e[0m"
elif [[ ${DISK} =~ ^/dev/vd[a-z]$ ]];
    then EFI="${DISK}1"
         ROOT="${DISK}2"
    echo -e "\e[32mThe EFI partition has been created on ${EFI}.\e[0m"
    echo
    echo -e "\e[32mThe ROOT partition has been created on ${ROOT}.\e[0m"
else echo -e "\e[31mError during partitioning, the disk type used is not recognized by the installation script. Installation process aborted.\e[0m"
     sleep 5s
     exit 0
fi

# Formatting the EFI partition to FAT 32
mkfs.vfat ${EFI}

# Formatting the ROOT partition to Btrfs
mkfs.btrfs -L ${ROOT_NAME} ${ROOT}

# Generation of Btrfs subvolumes on ROOT
echo "Partitioning of subvolumes ${ROOT}/mnt/@ & ${ROOT}/mnt/@home"
mount ${ROOT} /mnt
    btrfs su cr /mnt/@
    btrfs su cr /mnt/@home
umount /mnt

# Mounting of ROOT partitions with the final parameters
echo "Mounting of the ROOT partition"
mount -o noatime,commit=120,compress=zstd,discard=async,space_cache=v2,subvol=@ ${ROOT} /mnt
mount --mkdir -o noatime,commit=120,compress=zstd,discard=async,space_cache=v2,subvol=@home ${ROOT} /mnt/home

# Mounting of EFI partition with the final parameters
echo "Mounting of the EFI partition"
mount --mkdir ${EFI} /mnt/efi

# Clear
clear

# Regeneration of pacstrap keys
echo "Regeneration of pacman keys"
pacman-key -init
pacman-key --populate
pacman -Sy archlinux-keyring --noconfirm --needed

# Clear
clear

# Installation of the base system
echo "Installation of the base system"
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode amd-ucode btrfs-progs refind efibootmgr gptfdisk bash nano man-db tealdeer git mesa vulkan-radeon libva-mesa-driver mesa-vdpau --noconfirm --needed

# Clear
clear

# Installation of the boot loader (refind.conf)
echo "Installation of 'refind' (bootloader)"
refind-install --root /mnt
    sed -i 's/^timeout 20/timeout 3/' /mnt/efi/EFI/refind/refind.conf
    sed -i 's/^#enable_mouse/enable_mouse/' /mnt/efi/EFI/refind/refind.conf
    sed -i 's/^extra_kernel_version_strings linux-lts,linux/extra_kernel_version_strings linux-zen,linux-lts,linux-hardened,linux/' /mnt/efi/EFI/refind/refind.conf
    sed -i 's/^#fold_linux_kernels false/fold_linux_kernels false/' /mnt/efi/EFI/refind/refind.conf
    sed -i 's/^#default_selection "+,bzImage,vmlinuz"/default_selection "+,bzImage,vmlinuz"/' /mnt/efi/EFI/refind/refind.conf

# Retrieving the UUID and modifying the boot parameters (refind_linux.conf)
UUID=$(grep -oP 'UUID=\K[^\s]+' /mnt/boot/refind_linux.conf | head -n 1)
cat /root/easyarchscript/Bootloader/refind_linux.conf > /mnt/boot/refind_linux.conf
sed -i 's/(XXXXXXXX)/'${UUID}'/g' /mnt/boot/refind_linux.conf

# Clear
clear

#Chrooting
cp Chrooting.sh /mnt/home/
chmod +x /mnt/home/Chrooting.sh
cp DNS/dn0.txt /mnt/home/

export CHROOT_KEYBOARD="$KEYBOARD"
source /mnt/home/Chrooting.sh

sleep 10s
sudo arch-chroot /mnt /bin/bash -c "./home/Chrooting.sh; rm /home/Chrooting.sh; exit"
