# LanicOS <3 : Cool Arch Linux config 
---

This repo contains some `.config` files for LanicOS <3.

LanicOS <3 uses `hyprland`, `wofi` and GTK based apps (among others) to provide some kind of a Wayland based desktop environment with tiling windows. It aims to be customized to fit your style and needs, like I did. So the best thing you can do is fork this repo and make it your own <3.

I have centralized every config file here, even the ones located outside of the `.config` folder, the symlinks required to make it work are listed in the `README.md` and a helper `links.sh` file is provided to create theme.


# Dependencies

## Desktop environment

* hyprland
* waybar
* wofi
* gtk (3 and 4)
* nautilus

## Terminal

* kitty
* oh-my-zsh

## Utilities

* git

## Password manager (optional)

* pass
* gnupg
* pinentry (optional but will prevent you from retyping your GPG passkey everytime you search password, the GTK one fits the theme, not the other variants)
