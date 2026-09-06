# LanicOS <3 : Cool Arch Linux x Wayland config 
---

This repo contains some `.config` files for LanicOS <3.

> :warning: These were made for Arch Linux and are untested on other distros, although there are few chances of breakage since it's very high level

LanicOS <3 uses `hyprland`, `wofi` and GTK based apps (among others) to provide some kind of a Wayland based desktop environment with tiling windows. It aims to be customized to fit your style and needs. So the best thing you can do is fork this repo and make it your own <3.

I have centralized every config file here, even the ones located outside of the `.config` folder, the symlinks required to make it work are listed in the `README.md` and a helper `links.sh` file is provided to create them.

> Note : A noswaync branch is available if you want averything to be in waybar rather than swaync

## Special Thanks

* To [Keyitdev](https://github.com/Keyitdev) for [sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme) that I used as a base for my own SDDM theme (didn't have to change much tho)
* TODO : Find the article where I got the initial waybar config from

# 1. Dependencies

## Desktop environment

* hyprland
* hyprpaper
* hypridle
* hyprlock
* swaync
* waybar
* wofi
* sddm
* gtk (3 & 4)
* nautilus
* xorg-xwayland

# SDDM Themes

* qt6-svg
* qt6-virtualkeyboard
* qt6-multimedia-ffmpeg
* qt5-declarative

## Terminal

* kitty
* oh-my-zsh

## Utilities

* git
* cliphist

## Resources

* ttf-jetbrains-mono-nerd

## Session manager

It's an AUR package

* uwsm

## Shortcuts

|---------|-------------------------|
| Cmd + V | View clipboard history  |
|---------|-------------------------|

## Screenshots

* grim
* slurp
* swappy

## IDE (optional)

I use VSCodium as a daily driver IDE so I included some of my own keybings.

* VSCodium

## Password manager (optional)

* pass
* gnupg
* pinentry (optional but will prevent you from retyping your GPG passkey everytime you search password, the GTK one fits the theme, not the other variants)

# 2. Setup

1. Clone the repository in your .config folder.

```bash
git clone git@github.com:gummyWalrus/LanicOS.git ~/.config
```

2. Run `links.sh` to create necessary symlinks

## Customizing steps

### Kitty terminal

Run `kitty themes` in kiity to list all themes and pick one of your liking, you can then edit `kitty/current-theme.conf` to customize it furthermore.

Install additional fonts via [NerdFonts](https://www.nerdfonts.com/) and view them with `kitty +list-fonts` you can then choose one in `kitty/kitty.conf`.


## (optional) Password manager setup

Generate a GPG key

```bash
gpg --full-generate-key
```

Then run


```
gpg --list-secret-keys --keyid-format LONG
```

The output should be as follows :


```
sec   rsa4096/ABCD1234EFGH5678 YYYY-MM-DD
      Key fingerprint = ...
uid   [ultimate] Your Name <your@email.com>
```

You should get the `ABCD1234EFGH5678` part, that is your key's ID, use it to generate a password store.

```
pass init ABCD1234EFGH5678
```

Refer to the [pass documentation]() to insert, show and edit passwords.
