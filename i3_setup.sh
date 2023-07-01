#!/bin/bash

pacman -S xorg xorg-init i3 lxappearance archlinux-wallpaper picom firefox nitrogen kitty arc-gtk-theme papirus-icon-theme thunar rofi
process_id=$!
wait $process_id
echo "Exit status: $?"
sudo systemctl enable lightdm
process_id=$!
wait $process_id
echo "Exit status: $?"
yay lightdm-settings
echo "greeter-session=lightdm-slick-greeter"
echo "session-wrapper=/etc/lightdm/Xsession"
read -p "Press any key to continue..."
nvim /etc/lightdm/lightdm.conf
