clear
echo
echo
lsblk

echo "Please specify which disk you would like to erase."

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

# Killing process
#fuser -k ${DISK}

# Force unmounting disk
#umount -fl ${DISK}
dd if=/dev/zero of=${DISK} bs=1M status=progress
# Erasing the disk
#wipefs --all ${DISK}

# Rebooting on Install.sh
#clear
echo
echo
echo
echo
echo
echo "Would you like to Install Arch from the Install script? (Press 'y' to confirm, any other key to abort the installation process)."

read ANSWER

if [[ "${ANSWER}" == "y" || "${ANSWER}" == "Y" || "${ANSWER}" == "yes" || "${ANSWER}" == "Yes" ]];
    then source ./Install.sh
    else exit 1
fi
