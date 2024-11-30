#!/bin/bash

PACMAN_ARGS="--noconfirm --needed"

# Abort on errors
set -e

cd ..

sudo pacman --noconfirm -Syu

# essential tools without dotfiles
sudo pacman ${PACMAN_ARGS} -S eza wget udisks2 udiskie

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
wget -O ~/wallpaper.png https://images4.alphacoders.com/134/1344100.png
sudo pacman ${PACMAN_ARGS} -S sway swaybg waybar ttf-hack-nerd \
                              wmenu libappindicator-gtk3 grim
stow sway

# firefox
sudo pacman ${PACMAN_ARGS} -S firefox
echo "export BROWSER=/usr/bin/firefox" >> $HOME/.profile

# zathura pdf viewer
sudo pacman ${PACMAN_ARGS} -S zathura zathura-pdf-mupdf zathura-cb tesseract-data-deu

