#!/bin/bash

PACMAN_ARGS="--noconfirm --needed"

# Abort on errors
set -e
rm $HOME/.profile

# XDG base directory specification
echo "export XDG_CONFIG_HOME=$HOME/.config" >> $HOME/.profile
echo "export XDG_CACHE_HOME=$HOME/.cache" >> $HOME/.profile
echo "export XDG_DATA_HOME=$HOME/.local/share" >> $HOME/.profile

cd ..

# update initial system
sudo pacman --noconfirm -Syu

# essential tools without dotfiles
sudo pacman ${PACMAN_ARGS} -S eza fd ripgrep wget zenith udisks2 udiskie \
                              base-devel man-db man handlr-regex dua-cli

# rust
# -s -- -y at the end to make it non-interactive
# (following https://stackoverflow.com/questions/57251508/run-rustups-curl-fetched-installer-script-non-interactively)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# GNU stow (dotfiles manager)
sudo pacman ${PACMAN_ARGS} -S stow

# git
sudo pacman ${PACMAN_ARGS} -S git gitui
git pull
stow git

# zshell
stow zsh
sudo pacman ${PACMAN_ARGS} -S zsh
sudo chsh -s /usr/bin/zsh $USER

# neovim
sudo pacman ${PACMAN_ARGS} -S neovim
stow vim
stow nvim
nvim --headless +PlugInstall +qall
echo "export EDITOR=/usr/bin/nvim" >> $HOME/.profile
echo "export MANPAGER='nvim +Man!'" >> $HOME/.profile
handlr set 'text/*' nvim.desktop

# alacritty
sudo pacman ${PACMAN_ARGS} -S alacritty
stow alacritty
echo "export TERMINAL=/usr/bin/alacritty" >> $HOME/.profile
echo "export TERMINAL_CMD=\"alacritty -e\"" >> $HOME/.profile

# zellij
sudo pacman ${PACMAN_ARGS} -S zellij
stow zellij

# pipewire sound
sudo pacman ${PACMAN_ARGS} -S pipewire pipewire-audio pipewire-pulse \
                              pipewire-alsa pipewire-jack wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# bluetooth
sudo pacman ${PACMAN_ARGS} -S bluez bluez-utils blueman
sudo systemctl enable --now bluetooth.service

# sway
sudo pacman ${PACMAN_ARGS} -S sway swaybg swayimg swaylock swayidle \
                              wl-clipboard waybar ttf-hack-nerd brightnessctl \
                              libappindicator-gtk3 grim otf-font-awesome
stow sway
stow waybar
cargo install yofi # until yofi is available via arch repos
handlr set 'image/*' swayimg.desktop

# wallpaper
stow wallpaper
ln -f -s $HOME/.config/wallpaper/HMRGL_green_1920x1080.png $HOME/.config/sway/wallpaper.png

# fastfetch
sudo pacman ${PACMAN_ARGS} -S fastfetch
stow fastfetch

# firefox
sudo pacman ${PACMAN_ARGS} -S firefox
echo "export BROWSER=/usr/bin/firefox" >> $HOME/.profile

# zathura pdf viewer
sudo pacman ${PACMAN_ARGS} -S zathura zathura-pdf-mupdf zathura-cb tesseract-data-deu
handlr set 'application/pdf' zathura.desktop

# signal (desktop version)
sudo pacman ${PACMAN_ARGS} -S signal-desktop

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
