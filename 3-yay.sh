#!/bin/bash

clear

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
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

echo "DONE!"
