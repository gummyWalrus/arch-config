# LanicOS <3 : Neon Hyprland x Quickshell config
---

This repo contains some `.config` files for LanicOS <3.

> :warning: These were made for Arch Linux and are untested on other distros, although there are few chances of breakage since it's very high level

LanicOS <3 uses `hyprland` and `quickshell` to provide some kind of a Wayland based desktop environment with tiling windows. It aims to be customized to fit your style and needs. So the best thing you can do is fork this repo and make it your own <3.

I have centralized every config file here, even the ones located outside of the `.config` folder, the symlinks required to make it work are listed in the `README.md` and a helper `links.sh` file is provided to create them.

The Hyprland quote at the bottom of the wallaper / desktop is kept because I find it funny. Just uncomment in `hypr/hyprpaper.conf` to remove it

> Currently a lot of stuff is being migrated to quickshell, hoping to simplify as much as possible

## Special Thanks

Here are ressources that got me started on that config and inspired me to create this repo, especially on the design part.

* To [Keyitdev](https://github.com/Keyitdev) for [sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme) that I used as a base for my own SDDM theme (didn't have to change much tho)
* To [Tony, btw](https://tonybtw.com/) for his [tutorial on hyprland](https://tonybtw.com/tutorial/hyprland/), got me started indeed and I used he's waybar design as a base for the original waybar and the now quickshell bar featured in this repo.

**Huge thanks to all the maintainers of the packages listed below <3**

## Project TODOS

* Proper GTK theming so unthemed windows stop popping right in me face TwT
* Add notification client
* Add a settings "application"
      0. Audio output picker (Between HDMI, Bluetooth and shit...)
      1. Bluetooth
      2. Wif-Fi
      3. Monitors
      4. qs.config preferences
      5. Proper external services management ? (Calendar, mails ?, Google Drive eeeeeewwww among others)
      5. About page
* Remove unused config files
* Make a neovim config and make THE switch
* Configure window moving and resizing with keybinds
* Add a system monitor
* Add a player controller (music, browser videos) and volume mixer
* Add an emoji picker
* Proper lockscreen via hyprlock or quickshell
* Image viewer when opening images from nautilus
* Loading logo/throbber/animation after unlock
* Add a wallpaper picker
* Add calendar client when clicked on date (through thunderbird or is there an easier way ?)
* Add system tray client (I'm not much of a systray guy, so, not happening soon)

# 1. Dependencies

I tried to avoid AUR packages here because I'm scawed and do not want to review the cwode me self every time 👉👈 :3

## Desktop environment

Tools used to allow the full display and interactivity of the desktop environment, cherry-picked for control/customability rather than performance, also these guys should be pretty standard for a hyprland config.

* hyprland : Wayland compositor including tiling window management
* hyprpaper : Wallpaper deamon from hypr community
* hypridle : Idle deamon to automatically lock the session
* hyprlock : Lockscreen/Screensaver from hypr community
* quickshell : QT/QML utility to build custom panels and menus to build your own linux shell 
* sddm : Display manager that launches Hyprland and provides login security, replacing the classic tty login
* matugen : Generates a Material You palette from the wallpaper and writes it into every template (hyprland, hyprlock, kitty, GTK 3 & 4, quickshell, sddm), the actual theming engine of this whole thing
* jq : JSON cli, used by the matugen hyprpaper hook to list the monitors so the wallpaper changes on every screen
* gtk3 : GTK 3 toolkit, still used by firefox, thunderbird, gimp and the GTK file chooser portal, themed by `~/.config/gtk-3.0/`
* gtk4 + libadwaita : GTK 4 toolkit and the GNOME style library nautilus is built on, themed by `~/.config/gtk-4.0/`
* adw-gtk-theme : GTK 3 port of the libadwaita look, reads matugen's libadwaita color names so GTK 3 apps get the wallpaper colors too
* nautilus : GTK-based file explorer, used in GNOME
* xorg-xwayland : Compatibilty layer to allows x11 applications to run or Wayland 

> GTK 3 apps need to be pointed at the theme once : `gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark`
>
> GTK 3 apps running under XWayland (e.g. pinentry-gtk) can't read gsettings and fall back to light Adwaita, `~/.config/gtk-3.0/settings.ini` sets `gtk-theme-name=adw-gtk3-dark` for them

> To compare between bare nautilus and themed, you can use `XDG_CONFIG_HOME=$(mktemp -d) dbus-run-session nautilus` to open a bare, unthemed nautilus window. Same trick for GTK 3 apps, e.g. `XDG_CONFIG_HOME=$(mktemp -d) nwg-look`

# SDDM Themes

Utilities needed to make the current SDDM themes work

* qt6-svg : To display noice SVG icons especially those cool shutdown/reboot/suspend/hibernate buttons
* qt6-virtualkeyboard : To have a virtual keyboard on the login screen, handy if you only got a mouse and monitor lol
* qt6-multimedia-ffmpeg : To display animated backgrounds
* qt5-declarative : Just required I guess...

### TODOS

* Build one on my own to make sure every dep is justified

## Terminal

* kitty : My personal favorite terminal emulator, very basic and customizable, does the job
* oh-my-zsh : Cool .zshrc config that adds cool prompt theming with auto-suggestions and git plugins, among others... 

### TODOS

* Why does kitty needs internet access when refreshing the theme ??? Might wanna check that out

## Utilities

* git : I mean, do I really need to justify that one ?
* cliphist : Stores and manages a clipboard history

## Resources

* ttf-jetbrains-mono-nerd : We love a good old mono font with icons extensions <3

### TODOS

* Add an emoji font here
* Might add other nerd fonts here
* Might add other fonts for cooler theming

## Session manager

The session manager allows you to deamonize the long running programs such as quickshell so that they start with the graphical session, stop on logout, restart on crash and log to the journal instead of just being silent Hyprland childs.

> BEWARE : It's an AUR package, you might DIE if you use them TwT (oooooh be very scared !)

* uwsm

## Shortcuts

|---------|-------------------------|
| Cmd + V | View clipboard history  |
|---------|-------------------------|

### TODOS

* complete shortcuts

## Screenshots

* grim : the screenshot deamon for Wayland compositors
* slurp : Allows to select a specific zone to screenshot
* swappy : Annotate, draw stuff on your screenshot before saving it to disk

## IDE

I use VSCodium as a daily driver IDE so I included some of my own keybings.

> BEWARE : Also an AUR package

* VSCodium

## Password manager 

* pass : Manages your password via a folder in `$HOME`
* gnupg : For encryption and decryption, also you're GPG key being gated behind a password, it provides authentication to your password manager
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


## Password manager setup

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


# 4. Required services

Hyprland is supposed to run under uwsm in this, so long-running daemons are started by systemd instead of `hyprland.lua`.

| Service | Purpose |
|---|---|
| `hypridle.service` | Idle management (screen dim, lock, suspend) |
| `hyprpaper.service` | Wallpaper |
| `gpg-agent.socket` | GPG agent for `pass`, started on first use |

Logs for any of these can be read with `journalctl --user -u <service>`.

Enable hypridle and hyprpaper:

```bash
systemctl --user enable --now hypridle.service hyprpaper.service
```

`gpg-agent.socket` is enabled globally by the `gnupg` package on Arch, check it with:

```bash
systemctl --user status gpg-agent.socket
```

If it is inactive, enable it with `systemctl --user enable --now gpg-agent.socket`.

Clipboard history (`cliphist`) is still launched from `hyprland.lua`, wrapped in `uwsm app --`.
