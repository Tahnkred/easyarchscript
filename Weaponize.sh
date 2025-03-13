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
             FORMAT_DISK_1="${DISK}1"
             FORMAT_DISK_2="${DISK}2"
        break

    elif [[ ${ENTER_DISK} =~ ^sd[a-z]$ ]];
        then DISK="/dev/${ENTER_DISK}"
             FORMAT_DISK_1="${DISK}1"
             FORMAT_DISK_2="${DISK}2"
        break

    elif [[ ${ENTER_DISK} =~ ^/dev/nvme[0-9]+n1$ ]];
        then DISK=${ENTER_DISK}
             FORMAT_DISK_1="${DISK}p1"
             FORMAT_DISK_2="${DISK}p2"
        break

    elif [[ ${ENTER_DISK} =~ ^nvme[0-9]+n1$ ]];
        then DISK="/dev/${ENTER_DISK}"
             FORMAT_DISK_1="${DISK}p1"
             FORMAT_DISK_2="${DISK}p2"
        break

    elif [[ ${ENTER_DISK} =~ ^/dev/vd[a-z]$ ]];
        then DISK=${ENTER_DISK}
             FORMAT_DISK_1="${DISK}1"
             FORMAT_DISK_2="${DISK}2"
        break

    elif [[ ${ENTER_DISK} =~ ^vd[a-z]$ ]];
        then DISK="/dev/${ENTER_DISK}"
             FORMAT_DISK_1="${DISK}1"
             FORMAT_DISK_2="${DISK}2"
        break

    else echo -e "\e[31mError! The mentioned disk is not in the list or has been incorrectly named. Please try again.\e[0m"
         read ENTER_DISK
    fi
done

umount -f ${FORMAT_DISK_1}
umount -f ${FORMAT_DISK_2}

parted --script ${DISK} mklabel gpt
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
