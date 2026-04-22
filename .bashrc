# ~/.bashrc

# GUARD: exit early for non-interactive shells
[[ $- != *i* ]] && return

# STARTUP
clear && myfetch -d -c 8 -C " █"
eval "$(starship init bash)"

# ENVIRONMENT
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=micro
export VISUAL=micro

# NAVIGATION 
alias ..='cd ..'
alias ...='cd ...'
alias Docs="cd ~/Documents && y"

# FILE & SYSTEM
alias lsd='eza --icons'
alias ll='ls -lAh --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias grep='grep --color=auto'
alias fonts='fc-list -f "%{family}\n"'
alias tasks='btm'
alias untar="tar -xf"
alias c='clear'

# PACKAGE MANAGEMENT
alias yeet='yay -Rns'
alias yup='yay -Syu'
alias Apps='yay -Qe'

cleanup() {
    local orphans
    orphans=$(yay -Qdtq)
    if [[ -z "$orphans" ]]; then
        echo "No orphans found."
    else
        yay -Rns $orphans
    fi
}

# POWER
alias bye='sudo shutdown -h now'
alias loop='sudo reboot'

# EDITOR SHORTCUTS
alias todo="micro ~/Documents/todo.txt"
alias m="micro"
alias Settings="micro ~/.config/hypr/hyprland.conf"
alias brc="micro ~/.bashrc"
alias Steam="cd ~/.local/share/Steam/steamapps/common/"

# SSH
alias DROP="ssh -p 2200 zerodin@134.209.222.45"

# NETWORKING
alias myip='curl -s ifconfig.me && echo'
alias lanip='ip -br a'              # clean local interface view
alias ports='ss -tulnp'             # what's listening
alias listen='sudo tcpdump -i any'  # quick capture, append -w file.pcap to save

# GIT
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -10'
alias gp='git push'
alias gc='git commit -m'   # usage: gc "message"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# FUN
alias pool='clear && asciiquarium'
alias h='dbus-launch Hyprland'

# DOTFILES / LAB
alias labpush='cd ~/Documents/lab-notebook && git add . && git commit -m "update" && git push'

chezpush() {
    chezmoi re-add
    cd ~/.local/share/chezmoi
    git add .
    git commit -m "${1:-dotfiles update}"
    git push
    cd ~
}

# FUNCTIONS
# yazi with CWD tracking — changes shell directory on exit
y() {
	local tmp cwd
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Create a new lab notebook entry from template
# Usage: newbox <platform> <name>  e.g. newbox htb forest
newbox() {
  platform=$1
  name=$2
  date=$(date +%Y-%m-%d)
  path="$HOME/Documents/lab-notebook/${platform}/${date}-${name}.md"
  cp "$HOME/Documents/lab-notebook/.template.md" "$path"
  micro "$path"
}

# Machine-specific overrides
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
