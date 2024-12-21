#!/bin/bash

# Installaion of big (bloated) software packages for typical desktop environments

PACMAN_ARGS="--noconfirm --needed"

# paru AUR helper
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

# firefox
sudo pacman ${PACMAN_ARGS} -S firefox
echo "export BROWSER=/usr/bin/firefox" >> $HOME/.profile

# mupdf pdf viewer
sudo pacman ${PACMAN_ARGS} -S mupdf
handlr set 'application/pdf' mupdf.desktop

# signal (desktop version)
sudo pacman ${PACMAN_ARGS} -S signal-desktop

# cups printer system with brother HL-L2310D support
sudo pacman ${PACMAN_ARGS} -S cups cups-pdf
sudo systemctl enable --now cups.service
paru -S brother-hll2310d
echo "Open http://localhost:631 and add printer under Administration"

# syncthing
sudo pacman ${PACMAN_ARGS} -S syncthing
sudo systemctl enable --now syncthing@${USER}.service

# keepassxc
sudo pacman ${PACMAN_ARGS} -S keepassxc

# lutris config for starcraft gaming like it's 1998
sudo pacman ${PACMAN_ARGS} -S lutris wine-staging
sudo pacman ${PACMAN_ARGS} -S lib32-mesa vulkan-intel \
                              lib32-vulkan-intel vulkan-icd-loader \
                              lib32-vulkan-icd-loader
sudo pacman ${PACMAN_ARGS} -S --asdeps giflib lib32-giflib gnutls lib32-gnutls \
    v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins \
    lib32-alsa-plugins alsa-lib lib32-alsa-lib sqlite lib32-sqlite \
    libxcomposite lib32-libxcomposite ocl-icd lib32-ocl-icd libva lib32-libva \
    gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs \
    vulkan-icd-loader lib32-vulkan-icd-loader sdl2 lib32-sdl2
