#!/bin/bash

pacman -S xorg xorg-xinit i3 lxappearance archlinux-wallpaper picom nitrogen kitty arc-gtk-theme papirus-icon-theme thunar rofi xclip gpick
process_id=$!
wait $process_id
echo "Exit status: $?"
cp /etc/X11/xinit/xinitrc ~/.xinitrc
process_id=$!
wait $process_id
echo "Exit status: $?"
echo "Delete lines after fi in .xinitrc (chown) and add "exec i3""
read -p "Press any key to continue..."
