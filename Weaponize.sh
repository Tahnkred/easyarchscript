lsblk

echo "Please specify which disk you would like to reset."

read DISK

sudo umount -af

wipefs --all ${DISK}
