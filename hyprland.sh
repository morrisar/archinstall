#!/bin/bash

yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio hyprland-git
process_id=$!
wait $process_id
echo "Exit status: $?"
read -p "Press any key to continue..."
git clone --recursive https://github.com/hyprwm/Hyprland
process_id=$!
wait $process_id
echo "Exit status: $?"
read -p "Press any key to continue..."
cd Hyprland
sudo make install
process_id=$!
wait $process_id
echo "Exit status: $?"
read -p "Press any key to continue..."
