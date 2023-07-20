# Arch Base Install

### Basic setup:

##### Set font if needed:

fonts located in ```/usr/share/kbd/consolefonts/```

```bash
setfont <font>
```

##### Set root password to SSH into machine:

```bash
passwd
```

##### Show IP Address:

```bash
ip a
```

##### Connect to wifi:

```bash
iwctl
```



```bash
station wlan0 connect <ssid>
```

```bash
ping -c 4 archlinux.org
```

##### Check timezone settings:

```bash
timedatectl
timedatectl list-timezones | grep <search term>
timedatectl set-timezone <time zone>
```

- run ```timedatectl``` and make sure NTP service = active

### Disk setup:



##### Disk Partitions:

- Show if you are in EIFI mode:

```bash
ls /sys/firmware/efi/efivars
```

- Show disks and partitions:

```bash
lsblk # shows disks and partitions
```

- Show type of a current partition:

```bash
blkid /dev/<devicePartition>
```

- Create GPT partition table (for UEFI system)

- We need an EFI partition (unless one is already made) and root. We can have a separate home partition if desired 

- Create a swap partition if desired or install zram once installation of Arch is complete

```bash
gdisk /dev/<disk>
o #Deletes partition table
n #Creates a new partition
w #Write changes to disk
```



##### Format partitions:

- EFI:

```bash
mkfs.fat -F32 <partition>
```

- Swap:

```bash
mkswap <partition>
```

- BTRFS:

```bash
mkfs.btrfs <partition> #May need to use -f to force partition
```

```bash
blkid <partition> #Verify partition file type
```



##### Create sub volumes:

```bash
mount /dev/<root partition> /mnt
cd /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
```

```bash
umount /mnt
```

```bash
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@ 
    /dev/<partition> /mnt
```

```bash
mkdir -p /mnt/{boot/efi,home,var}
```

```bash
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@home 
    /dev/<partition> /mnt/home
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@var 
    /dev/<partition> /mnt/var
```

##### Mount EFI/Swap partition

```bash
mount /dev/<partition> /mnt/boot/efi
swapon /dev/<partition>
```

```bash
lsblk
```



##### Select the fastest mirrors for location:

```bash
reflector --country "United States" --age 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy
```



##### Install packages:

```bash
pacstrap /mnt base linux linux-firmware git neovim intel-ucode btrfs-progs
```

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

```bash
cat /mnt/etc/fstab #To check partitions
```



### Enter the arch installation

```bash
arch-chroot /mnt
```

```bash
cat /etc/fstab #To check partitions
```



##### Enter time zone: See ^ for timedatectl

```bash
ln -sf /usr/share/zoneinfo/<country>/<location> /etc/localtime
hwclock --systohc #Synchronizes hardware clock and system clock
```

```bash
nvim /etc/locale.gen #Uncomment en_US.UTF.8
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

```bash
nvim /etc/hostname
```



##### Set root password in the install:

```bash
passwd
```



##### Install additional packages:

```bash
pacman -S grub efibootmgr networkmanager networkmanager-applet dialog wpa_supplicant
mtools dosfstools reflector base-devel linux-headers bluez bluez-utilz cups 
hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack
bash-completion openssh rsync acpi acpi_call tlp sof-firmware acpid os-prober
ntfs-3g nvidia nvidia-utils nvidia-settings grub-btrfs
```



##### Grub-install

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
nvim /etc/default/grub #Uncomment Grub_Disable
grub-mkconfig -o /boot/grub/grub.cfg
```



##### Enable services:

```bash
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable acpid
```



##### Create User:

```bash
useradd -m <user-name>
passwd <user-name>
echo "<user-name> ALL=(ALL) ALL" >> /etc/sudoers.d/<user-name>
usermod -c 'Andrew' <user-name> #To add a full name to the user
```



##### Install manuals:

```bash
pacman -S man
```



##### Clean up:

```bash
exit #Return to USB
umount -R /mnt
reboot
```



##### After reboot:

```bash
nmtli #Network manager
ip -c a
```



##### Snapshot Utilites:

```bash
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
```

```bash
yay -S timeshift timeshift-autosnap
```

```bash
sudo timeshift --list-devices
sudo timeshift --snapshot-device /dev/<device>
sudo timeshift --create --comments "First Backup" --tags D
sudo grub-mkconfig -o /boot/grub/grub.cfg
```







##### Discord Replacement:

- webcord

<details>
<summary>Example</summary>
Put text here
</details>
