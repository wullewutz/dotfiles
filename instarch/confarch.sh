#!/bin/bash

PACMAN_ARGS="--noconfirm --needed"

# Abort on errors
set -e

cd ..

sudo pacman --noconfirm -Syu

# GNU stow (dotfiles manager)
sudo pacman ${PACMAN_ARGS} -S stow

# git
sudo pacman ${PACMAN_ARGS} -S git
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

# alacritty
sudo pacman ${PACMAN_ARGS} -S alacritty
stow alacritty

# zellij
sudo pacman ${PACMAN_ARGS} -S zellij
stow zellij

# sway
sudo pacman ${PACMAN_ARGS} -S sway waybar ttf-hack-nerd
stow sway

# misc cli tools without dotfiles
sudo pacman ${PACMAN_ARGS} -S eza ttf-hack-nerd
