### Arch Install
- Install git and neovim with Arch

### Nvidia Setup
- sudo pacman -S linux-headers
- sudo pacman -S nvidia-dkms
- add "nvidia_drm.modeset=1" to the end of "GRUB_CMDLINE_LINUX=" in etc/default/grub
- run "grub-mkconfig -o /boot/grub/grub.cfg"
- in /etc/mkinitcpio.conf add nvidia nvidia_modeset nvidia_uvm nvidia_drm to your MODULES
- run # mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img (make sure you have the linux-headers package installed first)
- add a new line to /etc/modprobe.d/nvidia.conf (make it if it does not exist) and add the line options nvidia-drm modeset=1
- Export these variables in your config:
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
- Install qt5-wayland, qt5ct and libva. Additionally nvidia-vaapi-driver-git (AUR) to fix crashes in some Electron-based applications, such as Unity Hub.

### Hyprland Install
- sudo pacman -S hyprland-nvidia

### Install kitty terminal
- sudo pacman -S kitty

### Starship

### Virt-manager
##### Dependencies:
-    gettext >= 0.19.6
-    python >= 3.4
-    gtk3 >= 3.22
-    libvirt-python >= 0.6.0
-    pygobject3 >= 3.31.3
-    libosinfo >= 0.2.10
-    gtksourceview >= 3
##### To install the software into /usr/local (usually), you can do:
- ./setup.py install
##### Optional software:
- virt-manager can optionally use libguestfs for inspecting the guests. For this, python-libguestfs >= 1.22 is needed.
