### Set keyboard layout and font
```ls /usr/share/kbd/keymaps/**/*.map.gz``` | grep if needed

```loadkeys {keys}```

Console fonts are located in /usr/share/kbd/consolefonts/ 

```setfont ter-132b```


### Verify boot mode
```cat /sys/firmware/efi/fw_platform_size```

If the command returns 64, then system is booted in UEFI mode and has a 64-bit X64 UEFI

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
