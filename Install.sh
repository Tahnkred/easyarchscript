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
#      #  break

#    elif ["${TIMEZONE}" = "Help" || "${TIMEZONE}" = "help" || "${TIMEZONE}" = "h" || "${TIMEZONE}" = "H"];
#        then    timedatectl list-timezones

#    else echo -e "\e[31mError! The specified time zone does not exist in 'list-timezones'. Please enter a valid time zone again.\e[0m"
#         echo -e "\e[1;32;1;4mHelp:\e[0m If you want to view the list of time zones, run the command '\e[32mtimedatectl list-timezones\e[0m'."
#    fi
#done

# Clear
clear

# Hard disk configuration
lsblk
echo
echo
echo
echo
echo "Please specify the path of the disk where you want to install the system. (Example: /dev/sda)."
read DISK

while true;
    do
    if [[ ${DISK} =~ ^/dev/sd[a-z]$ ]]
        then EFI="${DISK}1"
            ROOT="${DISK}2"
        break

    elif [[ ${DISK} =~ ^sd[a-z]$ ]];
        then EFI="/dev/${DISK}1"
            ROOT="/dev/${DISK}2"
        break

    elif [[ ${DISK} =~ ^/dev/nvme[0-9]+n1$ ]];
        then EFI="${DISK}p1"
            ROOT="${DISK}p2"
        break

    elif [[ ${DISK} =~ ^nvme[0-9]+n1$ ]];
        then EFI="/dev/${DISK}p1"
            ROOT="/dev/${DISK}p2"
        break

    elif [[ ${DISK} =~ ^/dev/vd[a-z]$ ]];
        then EFI="${DISK}1"
            ROOT="${DISK}2"
        break

    elif [[ ${DISK} =~ ^vd[a-z]$ ]];
        then EFI="/dev/${DISK}1"
            ROOT="/dev/${DISK}2"
        break

    else echo -e "\e[31mError! The mentioned disk is not in the list or has been incorrectly named. Please try again.\e[0m"
    fi
done
echo
echo
echo "How would you like to name your main partition?"
read ROOT_NAME

# Clear
clear

#Summary
echo "Here is the summary of the installation :"
echo
echo
echo
echo
echo "Keyboard layout            :          ${KEYBOARD}"
echo
echo
echo "Timezone                   :          ${TIMEZONE}"
echo
echo
echo "Installation disk          :          ${DISK}"
echo
echo
echo "Name of the main partition :          ${ROOT_NAME}"
echo
echo
echo
echo
echo
echo "Would you like to continue the installation? (y/N)"
echo
echo
#if process or if abort
read INSTALLATION

if [[ ${INSTALLATION} = "y" "Y" "Yes" "yes" "YEs" "yES" "yeS" "yEs" "YeS" ]];
    then echo "SEND VALUES TO OTHER FILES"
#else exit 1
