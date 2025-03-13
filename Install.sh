#!/usr/bin/env bash

# loadkeys mac-fr
# pacman -Sy git
# git clone https://github.com/Tahnkred/easyarchscript
# cd easyarchscript
# sh Install.sh
# to update : git pull origin main

# Clear
clear

# Check UEFI
cat /sys/firmware/efi/fw_platform_size

if [[ $(cat /sys/firmware/efi/fw_platform_size) == *64* ]];
    then echo -e "\e[32mUEFI is enabled on this device.\e[0m"
        sleep 0.5s
    else echo -e "\e[31mUEFI is not enabled on this device!\e[0m"
        sleep 5s
         exit 0
fi

# Clear
clear

#Keyboard layout
echo "Please enter your keyboard layout (enter the number below)"
echo
echo
#echo "1     -    Brazil           default"
#echo "2     -    Brazil           Macintosh"
#echo
echo "3     -    French           default"
echo "4     -    French           Macintosh"
echo
echo "5     -    Spain            default"
echo "6     -    Spain            Macintosh"
echo
echo "7     -    United Kingdom   default"
echo "8     -    United Kingdom   Macintosh"
echo
echo "9     -    United States    default"
echo "10    -    United States    Macintosh"
echo
echo
echo "0     -    other imput"
echo
echo
while true;
    do
    read KEYBOARD_ENTRY

    if [[ ${KEYBOARD_ENTRY} = "0" ]];
        then    echo "Please enter manually your keyboard layout"
                read KEYBOARD
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

#        elif [[ "${KEYBOARD_ENTRY}" = "1" ]];
#        then    KEYBOARD="fr-latin1"
#                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
#        break

#        elif [[ "${KEYBOARD_ENTRY}" = "2" ]];
#        then    KEYBOARD="fr-latin1"
#                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
#        break

        elif [[ ${KEYBOARD_ENTRY} = "3" ]];
        then    KEYBOARD="fr-latin1"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

        elif [[ ${KEYBOARD_ENTRY} = "4" ]];
        then    KEYBOARD="mac-fr"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

        elif [[ ${KEYBOARD_ENTRY} = "5" ]];
        then    KEYBOARD="es"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

        elif [[ ${KEYBOARD_ENTRY} = "6" ]];
        then    KEYBOARD="mac-es"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

        elif [[ ${KEYBOARD_ENTRY} = "7" ]];
        then    KEYBOARD="uk"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

        elif [[ ${KEYBOARD_ENTRY} = "8" ]];
        then    KEYBOARD="mac-uk"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

        elif [[ ${KEYBOARD_ENTRY} = "9" ]];
        then    KEYBOARD="us"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

        elif [[ ${KEYBOARD_ENTRY} = "10" ]];
        then    KEYBOARD="mac-us"
                echo -e "\e[32mThe keyboard layout has been set to "${KEYBOARD}".\e[0m"
        break

    else echo -e "\e[31mError! Please enter a value zone again.\e[0m"
    fi
done

sleep 0.5s

# Clear
clear

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

# Clear
clear

# Hard disk configuration
lsblk
echo "Please specify the path of the disk where you want to install the system. (Example: /dev/sda)."
read DISK
echo
echo
echo
echo "How would you like to name your main partition?"
read ROOT_NAME

# Formatting ${DISK}...
wipefs --all ${DISK}
lsblk
# Creating the GPT partition table
parted --script ${DISK} mklabel gpt

sleep 5s

# Creating the EFI and ROOT partitions

echo -e ',512M,L\n,,L' | sfdisk ${DISK} -f

sleep 5s

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
     exit 0
fi

sleep 5s

# Clear
clear

# Formatting the EFI partition to FAT 32
mkfs.vfat ${EFI}

sleep 5s

# Formatting the ROOT partition to Btrfs
mkfs.btrfs -L ${ROOT_NAME} ${ROOT}

sleep 5s

# Clear
clear

# Generation of Btrfs subvolumes on ROOT
echo "Partitioning of subvolumes ${ROOT}/mnt/@ & ${ROOT}/mnt/@home"
mount ${ROOT} /mnt
    btrfs su cr /mnt/@
    btrfs su cr /mnt/@home
umount /mnt

sleep 5s

# Mounting of ROOT partitions with the final parameters
echo "Mounting of the ROOT partition"
mount -o noatime,commit=120,compress=zstd,discard=async,space_cache=v2,subvol=@ ${ROOT} /mnt
mount --mkdir -o noatime,commit=120,compress=zstd,discard=async,space_cache=v2,subvol=@home ${ROOT} /mnt/home

# Mounting of EFI partition with the final parameters
echo "Mounting of the EFI partition"
mount --mkdir ${EFI} /mnt/efi

sleep 5s

# Clear
clear

# Regeneration of pacstrap keys
echo "Regeneration of pacman keys"
pacman-key -init
pacman-key --populate
pacman -Sy archlinux-keyring --noconfirm --needed

sleep 5s

# Clear
clear

# Installation of the base system
echo "Installation of the base system"
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode amd-ucode btrfs-progs refind efibootmgr gptfdisk bash nano man-db tealdeer git mesa vulkan-radeon libva-mesa-driver mesa-vdpau --noconfirm --needed

sleep 5s

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

sleep 5s

# Retrieving the UUID and modifying the boot parameters (refind_linux.conf)
UUID=$(grep -oP 'UUID=\K[^\s]+' /mnt/boot/refind_linux.conf | head -n 1)
cat /root/easyarchscript/Bootloader/refind_linux.conf > /mnt/boot/refind_linux.conf
sed -i 's/(XXXXXXXX)/'${UUID}'/g' /mnt/boot/refind_linux.conf

sleep 5s

# Clear
clear

# Copying Chrooting.sh on ${ROOT}/mnt/@home in order to execute it
cp /root/easyarchscript/Chrooting.sh /mnt/@home

# Sending values to Chrooting.sh in order to make it work
/mnt/@home/script2.sh "${KEYBOARD}"

#Chrooting
arch-chroot /mnt/@home sh Chrooting.sh
