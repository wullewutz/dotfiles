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

sudo pacman --noconfirm -Syu

# essential tools without dotfiles
sudo pacman ${PACMAN_ARGS} -S eza wget udisks2 udiskie base-devel man-db man handlr-regex

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# GNU stow (dotfiles manager)
sudo pacman ${PACMAN_ARGS} -S stow

# git
sudo pacman ${PACMAN_ARGS} -S git gitui
git pull
stow git

# zshell
stow zsh
sudo pacman ${PACMAN_ARGS} -S zsh
chsh -s /usr/bin/zsh

# neovim
sudo pacman ${PACMAN_ARGS} -S neovim
stow vim
stow nvim
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
wget -O $HOME/.config/sway/wallpaper.png \
    https://images4.alphacoders.com/134/1344100.png
sudo pacman ${PACMAN_ARGS} -S sway swaybg swayimg swaylock swayidle \
                              wl-clipboard waybar ttf-hack-nerd brightnessctl \
                              libappindicator-gtk3 grim
stow sway
cargo install yofi # until yofi is available via arch repos
handlr set 'image/*' swayimg.desktop

# firefox
sudo pacman ${PACMAN_ARGS} -S firefox
echo "export BROWSER=/usr/bin/firefox" >> $HOME/.profile

# zathura pdf viewer
sudo pacman ${PACMAN_ARGS} -S zathura zathura-pdf-mupdf zathura-cb tesseract-data-deu
handlr set 'application/pdf' zathura.desktop
