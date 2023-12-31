#!/bin/bash

clear
zoneinfo="America/New_York"
read -p "Enter hostname: " hostname
read -p "Enter user name: " username

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "Start reflector..."
reflector -c "United States" -p https -a 6 --sort rate --save /etc/pacman.d/mirrorlist

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync acpi acpi_call tlp sof-firmware acpid os-prober ntfs-3g man xdg-user-dirs neovim firefox git
process_id=$!
wait $process_id
echo "Exit status: $?"
read -p "Press any key to continue"

# ------------------------------------------------------
# set lang utf8 US
# ------------------------------------------------------
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf

# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo "$hostname" >>/etc/hostname
clear

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo "Set root password"
passwd root

# ------------------------------------------------------
# Add User
# ------------------------------------------------------
echo "Add user $username"
useradd -m -G wheel $username
passwd $username

# ------------------------------------------------------
# Enable Services
# ------------------------------------------------------
systemctl enable NetworkManager
process_id=$!
wait $process_id
echo "Exit status: $?"
systemctl enable bluetooth
process_id=$!
wait $process_id
echo "Exit status: $?"
systemctl enable sshd
process_id=$!
wait $process_id
echo "Exit status: $?"
systemctl enable tlp
process_id=$!
wait $process_id
echo "Exit status: $?"
systemctl enable reflector.timer
process_id=$!
wait $process_id
echo "Exit status: $?"
systemctl enable fstrim.timer
process_id=$!
wait $process_id
echo "Exit status: $?"
systemctl enable acpid
process_id=$!
wait $process_id
echo "Exit status: $?"
read -p "Press any key to continue"

# ------------------------------------------------------
# Grub installation
# ------------------------------------------------------
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
read -p "Press any key to continue"

# ------------------------------------------------------
# Add btrfs and setfont to mkinitcpio
# ------------------------------------------------------
# Before: BINARIES=()
# After:  BINARIES=(btrfs setfont)
# sed -i 's/BINARIES=()/BINARIES=(btrfs)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux
# read -p "Press any key to continue"
#
# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=nvim sudo -E visudo
usermod -aG wheel $username

# ------------------------------------------------------
# Copy installation scripts to home directory
# ------------------------------------------------------
cp /archinstall/3-yay.sh /home/$username
cp /archinstall/6-kvm.sh /home/$username

clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo "unmount -R /mnt"
echo "Please exit & shutdown (shutdown -h now), remove the installation media and start again."
echo "Important: Activate WIFI after restart with nmtui."
