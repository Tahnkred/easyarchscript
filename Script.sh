# Check UEFI
cat /sys/firmware/efi/fw_platform_size

if [[ $(cat /sys/firmware/efi/fw_platform_size)) == *64* ]];
    then echo -e "\e[32mUEFI is enabled on this device.\e[0m"
    else echo -e "\e[31mUEFI is not enabled on this device!\e[0m"
         exit 0
fi

# Waits 3 seconds.
sleep 3s

# Select timezone
echo "Please select your time zone (format: Continent/Capital. Example: Europe/Paris)"

while true; do
    read TIMEZONE

valid_timezones=("Africa/Abidjan" "Africa/Accra" "Africa/Addis_Ababa" "Africa/Algiers" "Africa/Asmara" ...) # Continue la liste

    if [[ "${valid_timezones[@]}" = "${TIMEZONE}" ]];
        then    echo -e "\e[32mThe time zone has been set to "${TIMEZONE}".\e[0m"
                timedatectl set-timezone "${TIMEZONE}"
        break

    elif ["${TIMEZONE}" = "Help" || "${TIMEZONE}" = "help" || "${TIMEZONE}" = "h" || "${TIMEZONE}" = "H"];
        then    timedatectl list-timezones

    else echo -e "\e[31mError! The specified time zone does not exist in 'list-timezones'. Please enter a valid time zone again.\e[0m"
         echo -e "\e[1;32;1;4mHelp:\e[0m If you want to view the list of time zones, run the command '\e[32mtimedatectl list-timezones\e[0m'."
    fi
done

# Enabling NTP synchronization
timedatectl set-ntp true

# Hard disk configuration
lsblk
echo "Please specify the path of the disk where you want to install the system. (Example: /dev/sda)."
read DISK

echo "How would you like to name your main partition?"
read ROOT_NAME

fdisk ${DISK}

# Creating the GPT partition table
g

# Creating the EFI partition
n
echo -e "\n"
echo -e "\n"
+512M
echo -e "\n"

# Creating the ROOT partition
n
echo -e "\n"
echo -e "\n"
echo -e "\n"
w
echo -e "\n"

# Creating variables for disk type names: NVMe or HDD/SSD

if [[ ${DISK} = "/dev/sda" || ${DISK} = "/dev/sdb" || ${DISK} = "/dev/sdc" ]]
    then EFI= ("{$DISK}1") ; ROOT= ("{$DISK}2")

elif [[ ${DISK} = "/dev/nvme0n1" || ${DISK} = "/dev/nvme1n1" || ${DISK} = "/dev/nvme2n1" ]]
    then EFI= ("{$DISK}p1") ; ROOT= ("{$DISK}p2")

else echo -e "\e[31mError during partitioning, the disk type used is not recognized by the installation script. Installation process aborted.\e[0m"
     exit 0
fi

echo "The EFI partition has been created on ${EFI}."
echo "The ROOT partition has been created on ${ROOT}."

#Formatting the EFI partition to FAT 32
mkfs.vfat ${EFI}

#Formatting the ROOT partition to Btrfs
mkfs.btrfs -L ${ROOT_NAME} ${ROOT}

