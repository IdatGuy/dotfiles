# dotfiles

My personal Arch Linux dotfiles managed with a bare git repo. Covers Hyprland, Waybar, Kitty, Wofi, Pywal, Cava, and more.

## Setup on a new machine

### 1. Clone the bare repo

```bash
git clone --bare git@github.com:IdatGuy/dotfiles.git $HOME/.dotfiles
```

### 2. Add the alias

Add this to your `~/.bashrc` temporarily so you can use it for the next steps:

```bash
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Then source it:

```bash
source ~/.bashrc
```

### 3. Suppress untracked file noise

```bash
dotfiles config status.showUntrackedFiles no
```

### 4. Check out the files

```bash
dotfiles checkout
```

If you get conflicts (existing files at the same paths), back them up first:

```bash
cd ~
dotfiles checkout 2>&1 | grep "^\s" | awk '{print $1}' | while read file; do
    mkdir -p ~/.config-backup/$(dirname "$file")
    mv ~/"$file" ~/.config-backup/"$file"
done
dotfiles checkout
```

### 5. Make the alias permanent

The checkout will have placed the `.bashrc` from this repo into your home directory, which includes the alias. Just source it again:

```bash
source ~/.bashrc
```

---

## Day-to-day usage

```bash
# Check what's changed
dotfiles status

# Stage and commit changes to already-tracked files
dotfiles commit -am "describe your change"

# Track a new file
dotfiles add ~/.config/someapp/config
dotfiles commit -m "track someapp config"

# Push to remote
dotfiles push

# Pull changes on another machine
dotfiles pull
```

---

## What's tracked

| Path | Contents |
|------|----------|
| `~/.config/hypr/` | Hyprland, hypridle, hyprlock |
| `~/.config/waybar/` | Bar config, styles, themes, scripts |
| `~/.config/kitty/` | Terminal config and theme |
| `~/.config/wofi/` | Launcher config and styles |
| `~/.config/wlogout/` | Logout menu config and icons |
| `~/.config/swaync/` | Notification center config |
| `~/.config/swayosd/` | OSD config |
| `~/.config/pypr/` | Pyprland scratchpad config |
| `~/.config/wal/` | Pywal templates and colorschemes |
| `~/.config/micro/` | Editor config and keybinds |
| `~/.config/yazi/` | File manager config |
| `~/.config/cava/` | Audio visualizer config and shaders |
| `~/.config/carapace/` | Shell completion config |
| `~/.config/starship.toml` | Prompt config |
| `~/.config/gtk-3.0/` | GTK theme settings |
| `~/.config/mimeapps.list` | Default app associations |
| `~/.bashrc` | Shell config, aliases, functions |

---

## Dependencies

Install yay (AUR helper) first, then grab the main packages:

```bash
# Core desktop
yay -S hyprland waybar kitty wofi wlogout swaync swayosd pyprland

# Theming
yay -S python-pywal

# Tools
yay -S micro yazi cava carapace-bin starship
```
