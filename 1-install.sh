#!/bin/bash
clear

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " sda1
read -p "Enter the name of the ROOT partition (eg. sda2): " sda2
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
mkfs.btrfs -f /dev/$sda2

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
mount /dev/$sda2 /mnt
(
	cd /mnt
	btrfs subvolume create /mnt/@
	btrfs subvolume create /mnt/@home
	btrfs subvolume create /mnt/@var
)
process_id=$!
wait $process_id
echo "Exit status: $?"
umount -f /mnt
process_id=$!
wait $process_id
echo "Exit status: $?"

mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,var}
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@home /dev/$sda2 /mnt/home
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@var /dev/$sda2 /mnt/var
mount /dev/$sda1 /mnt/boot/efi

read -p "Press any key to launch reflector and find the fastest mirrors"

# ------------------------------------------------------
# Select the fastest mirrors for location
# ------------------------------------------------------
reflector --country "United States" --age 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base linux linux-firmware intel-ucode btrfs-progs reflector git neovim

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >>/mnt/etc/fstab
cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 1-install.sh /mnt/archinstall/
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/
cp 4-zram.sh /mnt/archinstall/
cp 5-timeshift.sh /mnt/archinstall/
cp 7-kvm.sh /mnt/archinstall/
cp snapshot.sh /mnt/archinstall/
# cp i3_setup.sh /mnt/archinstall/
cp hyprland.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt
