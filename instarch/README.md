# Instarch

My personal opinionated way of installing Arch.

## Preparation

1. Get the installation iso image on usb stick as described in the arch wiki
2. Boot it

## Keyboard layout

```
# loadkeys de-latin1
```

## Update the system clock

```
# timedatectl
```

## Get and run stage 01 of archinstall

```
# curl -O https://raw.githubusercontent.com/wullewutz/dotfiles/refs/heads/master/instarch/01_instarch.sh
# chmod +x 01_instarch.sh
# ./01_instarch.sh
```

## What now?

Once the basic system is installed, remove the installation media and reboot.
In the fresh installed system, clone this repository.
```
cd ~
git clone https://github.com/wullewutz/dotfiles/ dot
```
Now run the stages 02, 03 and 04 as desired from the `instarch` folder.
