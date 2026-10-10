# LanicOS <3 : Neon Hyprland x Quickshell config
---

This repo contains some `.config` files for LanicOS <3.

> :warning: These were made for Arch Linux and are untested on other distros, although there are few chances of breakage since it's very high level, be aware !

LanicOS <3 uses `hyprland` and `quickshell` to provide some kind of a Wayland based desktop environment with tiling windows. It aims to be customized to fit your style and needs. So the best thing you can do is fork this repo and make it your own <3.

I have centralized every config file here, even the ones located outside of the `.config` folder, the symlinks required to make it work are listed in the `README.md` and a helper `links.sh` file is provided to create them.

The Hyprland quote at the bottom of the wallaper / desktop is kept because I find it funny. Just uncomment the line in `hypr/hyprpaper.conf` to remove it

> Currently a lot of stuff is being migrated to quickshell, hoping to simplify as much as possible

> Please note that the project was built on an Intel i7 PC and NVIDIA 4050 RTX GPU and not tested elsewhere, some driver dependencies might need to be adjusted

## Special Thanks

Here are ressources that got me started on that config and inspired me to create this repo, especially on the design part.

* [Keyitdev](https://github.com/Keyitdev) and his [sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme) used originally as a base SDDM theme that I **very lightly** tweaked, it got me into QML and helped me build up the courage the make a quickshell config. 
* [Tony, btw](https://tonybtw.com/) and his [tutorial on hyprland](https://tonybtw.com/tutorial/hyprland/), got me started indeed and I used his waybar design as a base for the original waybar and the now quickshell bar featured in this repo.

**Huge thanks to all the maintainers of the packages listed below <3**

# 1. Dependencies

I tried to avoid AUR packages here because I'm scawed and do not want to review the cwode me self every time 👉👈 :3

## Desktop environment

Tools used to allow the full display and interactivity of the desktop environment, cherry-picked for control, customability and extensibility rather than performance, also most of these guys should be pretty standard for a hyprland config.

* hyprland : Wayland compositor including tiling window management
* hyprcursor : For cursor management 
* hyprpaper : Wallpaper deamon from hypr community
* hypridle : Idle deamon to automatically lock the session
* hyprlock : Lockscreen/Screensaver from hypr community
* quickshell : QT/QML utility to build custom panels and windows, used to build that custom linux shell
* nautilus : GTK-based file explorer, used in GNOME and themed by me using Claude Opus 5.5
* gtk3 : GTK 3 toolkit, still used by firefox, thunderbird, gimp and the GTK file chooser portal, themed by `~/.config/gtk-3.0/`
* gtk4 + libadwaita : GTK 4 toolkit and the GNOME style library nautilus is built on, themed by `~/.config/gtk-4.0/`
* libva-nvidia-driver : Libva decodes video streams, this driver allows the videos to be decode on the NVIDIA hardware instead of Intel graphics
* qt6-virtualkeyboard : __Only if you use the greeter__, used for the virtual keyboard on the login screen, handy if you only got a mouse and monitor lol
* xorg-xwayland : Compatibilty layer to allows x11 applications to run or Wayland (I personnaly don't have any clients for this, but you and I might have one day)

## Theming
* matugen : Generates a Material You palette from the wallpaper and writes it into every template (hyprland, hyprlock, kitty, GTK 3 & 4, quickshell), the actual theming engine of this whole thing
* jq : JSON cli, used by the matugen hyprpaper hook to list the monitors so the wallpaper changes on every screen (TODO : check if really needed)
* adw-gtk-theme : GTK 3 port of the libadwaita look, reads matugen's libadwaita color names so GTK 3 apps get the wallpaper colors too


> GTK 3 apps need to be pointed at the theme once : `gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark`
>
> GTK 3 apps running under XWayland (e.g. pinentry-gtk) can't read gsettings and fall back to light Adwaita, `~/.config/gtk-3.0/settings.ini` sets `gtk-theme-name=adw-gtk3-dark` for them

> To compare between bare nautilus and themed, you can use `XDG_CONFIG_HOME=$(mktemp -d) dbus-run-session nautilus` to open a bare, unthemed nautilus window. Same trick for GTK 3 apps, e.g. `XDG_CONFIG_HOME=$(mktemp -d) nwg-look`

## Terminal

* kitty : My personal favorite terminal emulator, very basic and customizable, has a lot of features like panning and tabbing, which I don't use but will come handy at some point
* oh-my-zsh : Cool and extensible .zshrc config that adds prompt theming with auto-suggestions and git plugins among others... 

### TODOS

* Usage and shortcuts docs and customization on kitty

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

You should copy/save the `ABCD1234EFGH5678` part, that is your key's ID, use it to generate a password store.

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

# 5. AI Generated code

AI was strongly used during development for research, I am very much open to suggestions on outdated patterns that come with it.

* preferences/Displays section was vibe-coded, I kinda reviewed the code but I did not fully got my head around the geometry math
* gtk-4.0/gtk.css and gtk-3.0/gtk.css are fully AI generated as well and unreviewed, but it's just CSS so whatever
* AI was also used to build other parts of the project but the code was reviewed, tweaked and rewritten to the point that I think I can understand and own it

# 6. Project TODOS

* Add notification client
      1. Implement notfications actions (Click, copy, type a message)
      2. Display app and notifications image and icons
      3. Create a notification center to view full history
      4. Fix the notification card changing height when another notification is being pushed 
* Add a settings "application"
      1. Monitors : uses `Quickshell.Hyprland.monitors` and writes to `hypr/custom/monitors.lua`
            - Add monitor resolution
            - Add monitor scaling
      2. Theming section with wallpaper picker, cursors, icons and accent color (maybe theming colors someday)
      3. qs.config preferences
      4. Audio output picker (Between HDMI, Bluetooth and shit...)
      5. About page
      6. Bluetooth
      7. Wif-Fi
      8. Proper external services management ? (Calendar, mails ?, Google Drive eeeeeewwww among others)
* Polkit agent for app authentication so that they ask for root access through a popup
* Make the launcher sort apps by recent use
* Fix the Wired connection button in Settings Panel
* Create a password manager from `pass` using quickshell
* Configure window moving and resizing with keybinds
* Remove unused config files
* Add a system monitor, with turbostat
* Make a quickshell lockscreen and remove hyprlock
* Add an emoji picker
* Correct hyprland permissions
* Image viewer when opening images from nautilus
* Polish the greeter with nicer styling on error message and making them disappear after certain time
* Add calendar client when clicked on date (through thunderbird or is there an easier way ?)
* Add a player controller (music, browser videos) and volume mixer
* Make a neovim config and make THE switch
* Loading logo/throbber/animation after unlock
* Shutdown menu doesnt have the same font size as the settings panel, unify that
* Proper GTK theming so unthemed windows stop popping right in me face TwT : Partly done, experience will tell
* Add system tray client (I'm not much of a systray guy, so, not happening soon)