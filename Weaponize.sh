clear
echo
echo
lsblk
echo
echo
echo "Please specify which disk you would like to erase."
echo
echo
read ENTER_DISK

while true;
    do
    if [[ ${ENTER_DISK} =~ ^/dev/sd[a-z]$ ]]
        then DISK=${ENTER_DISK}
        break

    elif [[ ${ENTER_DISK} =~ ^sd[a-z]$ ]];
        then DISK="/dev/${ENTER_DISK}"
        break

    elif [[ ${ENTER_DISK} =~ ^/dev/nvme[0-9]+n1$ ]];
        then DISK=${ENTER_DISK}
        break

    elif [[ ${ENTER_DISK} =~ ^nvme[0-9]+n1$ ]];
        then DISK="/dev/${ENTER_DISK}"
        break

    elif [[ ${ENTER_DISK} =~ ^/dev/vd[a-z]$ ]];
        then DISK=${ENTER_DISK}
        break

    elif [[ ${ENTER_DISK} =~ ^vd[a-z]$ ]];
        then DISK="/dev/${ENTER_DISK}"
        break

    else echo -e "\e[31mError! The mentioned disk is not in the list or has been incorrectly named. Please try again.\e[0m"
         read ENTER_DISK
    fi
done

umount -f /mnt/efi
umount -f /mnt/home
umount -f /mnt
parted --script ${DISK} mklabel gpt
parted --script ${DISK} mkpart primary ext4 0% 100%
mkfs.ext4 -F ${DISK}1
wipefs -a ${DISK}1
parted --script ${DISK} mklabel gpt
echo
echo
lsblk
clear
echo
echo
echo "Would you like to Install Arch from the Install script? (Press 'y' to confirm, any other key to abort the installation process)."
echo
echo
read ANSWER

if [[ "${ANSWER}" == "y" || "${ANSWER}" == "Y" || "${ANSWER}" == "yes" || "${ANSWER}" == "Yes" ]];
    then source ./Install.sh
    else exit 1
fi
