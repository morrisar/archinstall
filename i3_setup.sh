#!/bin/bash

pacman -S xorg lightdm lightdm-slick-greeter i3 dmenu lxappearanc archlinux-wallpaper picom firefox nitrogen kitty arc-gtk-theme papirus-icon-theme thunar
systemctl enable lightdm dmenu-desktop
process_id=$!
wait $process_id
echo "Exit status: $?"
nvim /etc/lightdm/lightdm.conf
yay lightdm-settings
