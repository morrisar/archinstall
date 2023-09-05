# Install
### Set keyboard layout and font
```ls /usr/share/kbd/keymaps/**/*.map.gz``` | grep if needed

```loadkeys {keys}```

Console fonts are located in /usr/share/kbd/consolefonts/ 

```setfont ter-132b```


### Verify boot mode
```cat /sys/firmware/efi/fw_platform_size```

If the command returns 64, then system is booted in UEFI mode and has a 64-bit X64 UEFI

### Update the system clock
```timedatectl``` (America/New_York)

### Format hard drive
List drives with 
```lsblk``` 

Parition drives with gdisk /dev/{drive to be formatted}

EFI partition = At least 300M

Root partition

Swap if desired

```mkfs.fat -F32 /dev/EFI_partion```

```mkfs.ext4 /dev/root_partion```

```mkswap /dev/swap_partition```

### Mount the filesystems
```mount /dev/root_partition /mnt```

```mount --mkdir /dev/EFI_partition /mnt/boot```

```swapon /dev/swap_partition```

### Select mirrors
Install reflector with ```pacman -S relector```

Launch reflector with ```reflector --country "United States" --age 6 --sort rate --save /etc/pacman.d/mirrorlist```

Sync mirrors ```pacman -Syyy <maybe -Sy only>``` 

### Install essential packages
```pacstrap -K /mnt base linux linux-firmware {editor ie neovim}```
# Configure
generate fstab file using ```genfstab -U /mnt >> /mnt/etc/fstab

check with ```cat /mnt/etc/fstab``` and edit if needed

```arch-chroot /mnt```

set timezone with ```ln -sf /usr/share/zoneinfo/*Region*/*City* /etc/localtime```

```hwclock --systohc```

### Install additional packages
```pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync acpi acpi_call tlp sof-firmware acpid os-prober ntfs-3g man xdg-user-dirs neovim firefox git amd-ucode intel-ucode```

### Localization
Edit /etc/locale.gen and uncomment ```en_US.UTF-8 UTF-8``` and other needed UTF-8 locales. 

```locale-gen```

Create the locale.conf file and set the LANG variable

```/etc/locale.conf```

```LANG=en_US.UTF-8```

If console keyboard layout was set, make changes persistent in vconsole.conf

```/etc/vconsole.conf```

```KEYMAP=de-Latin1```
### Create the hostname file:

/etc/hostname

yourhostname

### If needed:
modify mkinitcpio.conf and reacreate the initramfs image with ```mkinitcpio -P```

### set root password
```passwd```

### Grub

May have to ```mkdir /boot/efi```
```grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB```
```grub-mkconfig -o /boot/grub/grub.cfg```

### Add user
```useradd -m -G wheel $username```

```passwd $username```

### Enable Services
systemctl enable NetworkManager

systemctl enable bluetooth

systemctl enable sshd

systemctl enable tlp

systemctl enable reflector.timer

systemctl enable fstrim.timer

systemctl enable acpid

### Edit sudoers file
Uncomment %wheel group in sudoers (around line 85) /etc/sudoers

usermod -aG wheel $username

# Exit and reboot
Exit the chroot environment by typing exit or pressing Ctrl+d.

Optionally manually unmount all the partitions with umount -R /mnt: this allows noticing any "busy" partitions, and finding the cause with fuser(1).

Finally, restart the machine by typing reboot: any partitions still mounted will be automatically unmounted by systemd. Remember to remove the installation medium and then login into the new system with the root account. 
