#!/bin/bash

PACMAN_ARGS="--noconfirm --needed"

# Abort on errors
set -e
rm $HOME/.profile

# XDG base directory specification
echo "export XDG_CONFIG_HOME=$HOME/.config" >> $HOME/.profile
echo "export XDG_CACHE_HOME=$HOME/.cache" >> $HOME/.profile
echo "export XDG_DATA_HOME=$HOME/.local/share" >> $HOME/.profile

# create user bin directory
mkdir -p $HOME/.local/bin

cd ..

# update initial system
sudo pacman --noconfirm -Syu

# essential tools without dotfiles
sudo pacman ${PACMAN_ARGS} -S eza fd ripgrep wget zenith udisks2 udiskie \
                              base-devel man-db man dua-cli usbutils

# handlr-regex (xdg-open replacement for wayland)
sudo pacman ${PACMAN_ARGS} -S handlr-regex
# shadow xdg-open (as proposed here: https://github.com/Anomalocaridid/handlr-regex)
cat << 'EOF' > $HOME/.local/bin/xdg-open
#!/bin/sh
handlr open $@
EOF
chmod +x $HOME/.local/bin/xdg-open

# rust
sudo pacman ${PACMAN_ARGS} -S rustup
rustup default stable
rustup component add rust-src
rustup component add rust-analyzer

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

# alacritty terminal
sudo pacman ${PACMAN_ARGS} -S alacritty
stow alacritty
echo "export TERMINAL=/usr/bin/alacritty" >> $HOME/.profile
echo "export TERMINAL_CMD=\"alacritty -e\"" >> $HOME/.profile

# zellij terminal multiplexer
sudo pacman ${PACMAN_ARGS} -S zellij
stow zellij

#yazi file manager
sudo pacman ${PACMAN_ARGS} -S yazi ffmpeg p7zip jq poppler fd ripgrep fzf \
                              zoxide imagemagick ueberzugpp
#remove remains of previous installations
rm -rf $HOME/.config/yazi/flavors
rm -f $HOME/.config/yazi/package.toml
ya pack -a bennyyip/gruvbox-dark
stow yazi

# pipewire sound
sudo pacman ${PACMAN_ARGS} -S pipewire pipewire-audio pipewire-pulse \
                              pipewire-alsa pipewire-jack wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# bluetooth
sudo pacman ${PACMAN_ARGS} -S bluez bluez-utils blueman
sudo systemctl enable --now bluetooth.service

# network-manager-applet
sudo pacman ${PACMAN_ARGS} -S network-manager-applet

# sway window mananger
sudo pacman ${PACMAN_ARGS} -S sway swaybg swayimg swaylock swayidle \
                              wl-clipboard waybar ttf-hack-nerd brightnessctl \
                              libappindicator-gtk3 grim otf-font-awesome \
                              mako
stow sway
stow waybar
stow mako
cargo install yofi # until yofi is available via arch repos
handlr set 'image/*' swayimg.desktop

# wallpaper
stow wallpaper
ln -f -s $HOME/.config/wallpaper/HMRGL_gruvbox01.png $HOME/.config/sway/wallpaper.png

# fastfetch
sudo pacman ${PACMAN_ARGS} -S fastfetch
stow fastfetch

