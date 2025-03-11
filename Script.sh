#!/usr/bin/env bash

# Check UEFI
cat /sys/firmware/efi/fw_platform_size

if [[ $(cat /sys/firmware/efi/fw_platform_size) == *64* ]];
    then echo -e "\e[32mUEFI is enabled on this device.\e[0m"
    else echo -e "\e[31mUEFI is not enabled on this device!\e[0m"
        sleep 5s
         exit 0
fi

# Select timezone
echo "Please select your time zone (format: Continent/Capital. Example: Europe/Paris)"

#while true;
    #do
    read TIMEZONE

#    #valid_timezones=("Africa/Abidjan" "Africa/Accra" "Africa/Addis_Ababa" "Europe/Paris" "Africa/Asmara" ...) # Continue la liste

#    #if [[ "${valid_timezones[@]}" = "${TIMEZONE}" ]];
#     #   then    echo -e "\e[32mThe time zone has been set to "${TIMEZONE}".\e[0m"
                timedatectl set-timezone "${TIMEZONE}"
#      #  break

#    elif ["${TIMEZONE}" = "Help" || "${TIMEZONE}" = "help" || "${TIMEZONE}" = "h" || "${TIMEZONE}" = "H"];
#        then    timedatectl list-timezones

#    else echo -e "\e[31mError! The specified time zone does not exist in 'list-timezones'. Please enter a valid time zone again.\e[0m"
#         echo -e "\e[1;32;1;4mHelp:\e[0m If you want to view the list of time zones, run the command '\e[32mtimedatectl list-timezones\e[0m'."
#    fi
#done

# Enabling NTP synchronization
timedatectl set-ntp true

# Hard disk configuration
lsblk
echo "Please specify the path of the disk where you want to install the system. (Example: /dev/sda)."
read DISK

echo "How would you like to name your main partition?"
read ROOT_NAME

# Formatting ${DISK}...
echo -e wipefs -a ${DISK}

# Creating the GPT partition table
echo label: gpt

# Creating the EFI and ROOT partitions

echo -e ',512M,L\n,,L\n' | sfdisk ${DISK}

# Creating variables for disk type names: NVMe or HDD/SSD

if [[ ${DISK} =~ ^/dev/sd[a-z]$ ]]
    then EFI= $DISK1 ; ROOT= $DISK2
    echo "The EFI partition has been created on ${EFI}."
    echo "The ROOT partition has been created on ${ROOT}."

elif [[ ${DISK} =~ ^/dev/nvme[0-9]+n1$ ]];
    then EFI= $DISKp1 ; ROOT= $DISKp2
    echo "The EFI partition has been created on ${EFI}."
    echo "The ROOT partition has been created on ${ROOT}."

else echo -e "\e[31mError during partitioning, the disk type used is not recognized by the installation script. Installation process aborted.\e[0m"
     exit 0
fi

# Formatting the EFI partition to FAT 32
mkfs.vfat $EFI

# Formatting the ROOT partition to Btrfs
#mkfs.btrfs -L $ROOT_NAME $ROOT

# Generation of Btrfs subvolumes on ROOT
#echo "Partitioning of subvolumes ${ROOT}/mnt/@ & ${ROOT}/mnt/@home"
#mount ${ROOT} /mnt
#    btrfs su cr /mnt/@
#    btrfs su cr /mnt/@home
#umount /mnt

# Mounting of ROOT partitions with the final parameters
#echo "Mounting of the ROOT partition"
#mount -o noatime,commit=120,compress=zstd,discard=async,space_cache=v2,subvol=@ ${ROOT} /mnt
#mount --mkdir -o noatime,commit=120,compress=zstd,discard=async,space_cache=v2,subvol=@home ${ROOT} /mnt/home

# Mounting of EFI partition with the final parameters
#echo "Mounting of the EFI partition"
#mount --mkdir ${EFI} /mnt/efi

# Regeneration of pacstrap keys
#echo "Regeneration of pacman keys"
#pacman-key -init
#pacman-key --populate
#pacman -Sy archlinux-keyring --noconfirm --needed

# Installation of the base system
#echo "Installation of the base system"
#pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode amd-ucode btrfs-progs refind efibootmgr gptfdisk bash nano man-db tealdeer git mesa vulkan-radeon libva-mesa-driver mesa-vdpau --noconfirm --needed

# Installation of the boot loader
#echo "Installation of 'refind' (bootloader)"
#refind-install --root /mnt
    #sed -i 's/^#oldcommand/timeout 3/' /mnt/efi/EFI/refind/refind.conf
#    sed -i 's/^#enable_mouse/enable_mouse/' /mnt/efi/EFI/refind/refind.conf
    #sed -i 's/^#oldcommand/extra_kernel_version_strings linux-zen,linux-lts,linux-hardened,linux/' /mnt/efi/EFI/refind/refind.conf
    #sed -i 's/^#oldcommand/fold_linux_kernels false/' /mnt/efi/EFI/refind/refind.conf
    #sed -i 's/^#oldcommand/default_selection "+,bzImage,vmlinuz"/' /mnt/efi/EFI/refind/refind.conf

# Retrieving the UUID and modifying the boot parameters (refind_linux.conf)
#UUID=$(grep -oP 'UUID=\K[^\s]+' /mnt/boot/refind_linux.conf)
#echo ""Boot using standard options"     "root=UUID=${UUID} rw add_efi_memmap zswap.enabled=0 rootflags=subvol=@ initrd=@\boot\intel-ucode.img initrd=@\boot\amd-ucode.img initrd=@\boot\initramfs-%v.img"

#"Boot using fallback initramfs"   "root=UUID=${UUID} rw add_efi_memmap zswap.enabled=0 rootflags=subvol=@ initrd=@\boot\intel-ucode.img initrd=@\boot\amd-ucode.img initrd=@\boot\initramfs-%v-fallback.img"

#"Boot to terminal"                "root=UUID=${UUID} rw add_efi_memmap zswap.enabled=0 rootflags=subvol=@ initrd=@\boot\intel-ucode.img initrd=@\boot\amd-ucode.img initrd=@\boot\initramfs-%v.img systemd.unit=multi-user.target"" > /mnt/boot/refind_linux.conf

#Chrooting
#arch-chroot /mnt /bin/bash
