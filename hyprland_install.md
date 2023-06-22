### Arch Install
[x] Install git and neovim with Arch

### For creating defacult directories:
[x] Install xdg-user-dirs
[x] run xdg-users-dirs-update

### Yay Install:
[] pacman -S --needed git base-devel
[] git clone https://aur.archlinux.org/yay.git
[] cd yay
[] makepkg -si

### Nvidia Setup
[] sudo pacman -S linux-headers
[] sudo pacman -S nvidia-dkms
[] add "nvidia_drm.modeset=1" to the end of "GRUB_CMDLINE_LINUX=" in etc/default/grub
[] run "grub-mkconfig -o /boot/grub/grub.cfg"
[] in /etc/mkinitcpio.conf add nvidia nvidia_modeset nvidia_uvm nvidia_drm to your MODULES
[] run # mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img (make sure you have the linux-headers package installed first)
[] add a new line to /etc/modprobe.d/nvidia.conf (make it if it does not exist) and add the line options nvidia-drm modeset=1
[] Export these variables in your config:
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
[] Install qt5-wayland, qt5ct and libva. Additionally nvidia-vaapi-driver-git (AUR) to fix crashes in some Electron-based applications, such as Unity Hub.

### Hyprland Install
[] sudo pacman -S hyprland-nvidia

### Install kitty terminal
[x] sudo pacman -S kitty

### Starship

### Install manual pages
[x] sudo pacman -S man

### Virt-manager
##### Dependencies:
[]    gettext python gtk3 libvirt-python pygobject3 libosinfo gtksourceview 
##### Optional software:
[] virt-manager can optionally use libguestfs for inspecting the guests. For this, python-libguestfs >= 1.22 is needed.
##### Install on guest OS:
[] spice-vdagent
