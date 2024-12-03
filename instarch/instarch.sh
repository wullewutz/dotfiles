#!/bin/bash

# Abort on errors
set -e

# Hardcoded variables
TIMEZONE="Europe/Berlin"
LOCALE="en_US.UTF-8"
KEYMAP="de-latin1"

# Prompt user for passwords
echo "Username"
read USER
echo "Password for '${USER}':"
read -s USER_PASSWORD
echo "Enter swapfile size e.g. '33G':"
read SWAP_SIZE
echo "Host name"
read HOSTNAME
echo "Disk e.g. '/dev/sda' or '/dev/nvme0n1'"
read DISK

# Determine partition suffix based on disk type
if [[ "$DISK" =~ nvme ]]; then
  # nvme disk name partitions /dev/nvme0n1p1
  PART_SUFFIX="p"
else
  # ssd disk name partitions /dev/sda1
  PART_SUFFIX=""
fi

# Partition the disk
echo "Partitioning the disk..."
parted -s "$DISK" mklabel gpt \
    mkpart primary fat32 1MiB 1GiB set 1 esp on \
    mkpart primary ext4 1GiB 100%

# Format the partitions
echo "Formatting the partitions..."
mkfs.fat -F32 "${DISK}${PART_SUFFIX}1"
mkfs.ext4 "${DISK}${PART_SUFFIX}2"

# Setup LUKS encryption on the second partition
echo "Setting up LUKS encryption..."
cryptsetup luksFormat --type luks2 "${DISK}${PART_SUFFIX}2"
cryptsetup open "${DISK}${PART_SUFFIX}2" cryptroot

# Format and mount the encrypted partition
echo "Formatting the encrypted partition..."
mkfs.ext4 /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt

# Mount the EFI partition
echo "Mounting the EFI partition..."
mkdir -p /mnt/boot
mount "${DISK}${PART_SUFFIX}1" /mnt/boot

# Get UUID of the encrypted partition
UUID=$(blkid -s UUID -o value "${DISK}${PART_SUFFIX}2")

# Install base system
echo "Installing base system..."
pacstrap /mnt base linux linux-firmware 

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configure the system
echo "Configuring the system..."
arch-chroot /mnt /bin/bash <<EOF

# Set the timezone
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc

# Set the locale
echo "${LOCALE} UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}" > /etc/locale.conf

# Set the keymap
echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf

# Set the hostname
echo "${HOSTNAME}" > /etc/hostname
echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

# Disable root user
passwd -l root

# Install essential tools
pacman --noconfirm -S neovim git stow networkmanager sudo less ripgrep nfs-utils

# Create a user and put it into wheel group
useradd -m -G wheel ${USER}
echo "${USER}:${USER_PASSWORD}" | chpasswd

# Enable sudo for wheel group
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel

# Create and configure swapfile
mkswap -U clear --size ${SWAP_SIZE} --file /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
swapon /swapfile

# GRUB
pacman --noconfirm -S grub efibootmgr cryptsetup

# Enable GRUB support for encrypted disks
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub

# Add kernel parameters for LUKS
echo "GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${UUID}:cryptroot root=/dev/mapper/cryptroot\"" >> /etc/default/grub

# Install GRUB to the EFI directory
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Install GRUB to the EFI directory
grub-mkconfig -o /boot/grub/grub.cfg

# Add LUKS hook to mkinitcpio
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Enable essential services
systemctl enable NetworkManager

# enable multilib
echo "[multilib]" >> /etc/pacman.conf 
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

EOF

# Unmount and finish
echo "Unmounting and finishing..."
swapoff /mnt/swapfile
umount -R /mnt
cryptsetup close cryptroot || echo "Warning: Unable to close cryptroot. Ensure it is unmounted and try manually."
echo "Installation complete. Reboot your system."

