#!/bin/bash
clear

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " sda1
read -p "Enter the name of the ROOT partition (eg. sda2): " sda2
read -p "Enter the name of the swap partition (keep it empty if not needed):" sda3
# read -p "Enter the name of the VM partition (keep it empty if not required): " sda3

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true
timedatectl set-timezone America/New_York

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
mkfs.fat -F 32 /dev/$sda1
mkfs.ext4 /dev/$sda2
mkswap /dev/$sda3

mount /dev/$sda2 /mnt
mount --mkdir /dev/$sda1 /mnt/boot
swapon /dev/$sda3

read -p "Press any key to launch reflector and find the fastest mirrors"

# ------------------------------------------------------
# Select the fastest mirrors for location
# ------------------------------------------------------
reflector --country "United States" --age 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base linux linux-firmware intel-ucode amd-ucode

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >>/mnt/etc/fstab
cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
# cp 1-install.sh /mnt/archinstall/
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/
cp 6-kvm.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt
