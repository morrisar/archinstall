#!/bin/bash

clear

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
while true; do
	read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
	case $yn in
	[Yy]*)
		echo "Installation started."
		break
		;;
	[Nn]*)
		exit
		break
		;;
	*) echo "Please answer yes or no." ;;
	esac
done

# -----------------------------------------------------
# Install Timeshift
# -----------------------------------------------------
yay --noconfirm -S timeshift

echo "DONE!"
echo "You can create snapshots and update the GRUB Bootloader with ./snapshot.sh"
