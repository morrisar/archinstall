### Arch Install
[x] Install git and neovim with Arch

### For creating default directories:
[x] Install xdg-user-dirs
[x] run xdg-users-dirs-update

### Install manual pages
[x] sudo pacman -S man

### Yay Install:
[x] pacman -S --needed git base-devel
[x] git clone https://aur.archlinux.org/yay.git
[x] cd yay
[x] makepkg -si

### Nvidia Setup
[x] sudo pacman -S linux-headers
[x] sudo pacman -S nvidia-dkms
[x] add "nvidia_drm.modeset=1" to the end of "GRUB_CMDLINE_LINUX=" in etc/default/grub
[x] run "grub-mkconfig -o /boot/grub/grub.cfg"
[x] in /etc/mkinitcpio.conf add nvidia nvidia_modeset nvidia_uvm nvidia_drm to your MODULES
[x] run # mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img (make sure you have the linux-headers package installed first)
[x] add a new line to /etc/modprobe.d/nvidia.conf (make it if it does not exist) and add the line options nvidia-drm modeset=1
[] Export these variables in your config:
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
[x] Install qt5-wayland, qt5ct and libva. Additionally ~~nvidia-vaapi-driver-git (AUR)~~ to fix crashes in some Electron-based applications, such as Unity Hub.

### Hyprland Install
[x] sudo pacman -S hyprland-nvidia

### Install kitty terminal
[x] sudo pacman -S kitty

## REBOOT

### Starship
1. Install nerd-fonts
2. curl -sS https://starship.rs/install.sh | sh
3. create starship.toml in .config

### Virt-manager
##### Dependencies:
[]    gettext python gtk3 libvirt-python pygobject3 libosinfo gtksourceview 
##### Optional software:
[] virt-manager can optionally use libguestfs for inspecting the guests. For this, python-libguestfs >= 1.22 is needed.
##### Install on guest OS:
[] spice-vdagent

### Network Manager
- nmtli
