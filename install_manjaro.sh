#!/bin/bash
set -e

echo "Starting Manjaro Setup..."

# 1. Update System & Install Base Devel
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git

# 2. Install AUR Helper (yay) if not present
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# 3. Install Core Dependencies
# Mapped from Homebrew to Arch equivalent
# zsh-autosuggestions/syntax-highlighting are skipped as we are moving to Bash
DEPENDENCIES=(
    neovim
    yt-dlp
    mpv
    tmux
    gnupg
    stow
    fzf
    zoxide
    starship
    eza
    tmuxp
    ripgrep
    w3m
    newsboat
    wezterm
    nvm
)

echo "Installing core packages..."
sudo pacman -S --needed --noconfirm "${DEPENDENCIES[@]}"

# 4. Install AUR Packages
# browsh is best installed via AUR on Arch-based systems
echo "Installing AUR packages..."
yay -S --needed --noconfirm browsh-bin

# 5. Create Directories
echo "Creating config directories..."
mkdir -p ~/.config/wezterm
mkdir -p ~/.newsboat
mkdir -p ~/.config/tmux 
mkdir -p ~/.config/nvim 
mkdir -p ~/scripts
mkdir -p ~/.nvm

# 6. Fix Permissions for Scripts
# Assumes script is running from dotfiles root
if [ -d "./scripts" ]; then
    find ./scripts -name "*.sh" -exec chmod +x {} +
fi

# 7. Stow Configurations
# We skip 'zsh' since we are generating a .bashrc below
echo "Stowing dotfiles..."
stow -t ~/scripts scripts
stow -t ~/.config/nvim nvim
stow -t ~/.config/wezterm wezterm
stow -t ~/.newsboat newsboat
stow -t ~/.config/tmux tmux

# 8. Generate .bashrc (Ported from your .zshrc)
echo "Generating ~/.bashrc..."

cat << 'EOF' > ~/.bashrc
# --- Generated .bashrc from dotfiles install script ---

# 1. Path Configuration
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/_dev/flutter/bin:$PATH"
# Ruby path might vary on Manjaro, checking generic location
if [ -d "$HOME/.gem/ruby" ]; then
    export PATH="$(ls -d $HOME/.gem/ruby/*/bin | tail -n1):$PATH"
fi

export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

export PATH="$HOME/.local/bin:$PATH"
# 2. History Settings
HISTSIZE=5000
HISTFILE=~/.bash_history
shopt -s histappend

# 3. Editor
export EDITOR='nvim'

# 4. Starship Prompt
eval "$(starship init bash)"

# 5. Zoxide (Better cd)
eval "$(zoxide init --cmd cd bash)"

# 6. FZF Setup (Sourcing standard Arch locations)
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# 7. NVM (Node Version Manager)
# Arch installs nvm script to /usr/share/nvm
source /usr/share/nvm/init-nvm.sh

# 8. Aliases
alias c='clear'
alias nv='nvim .'
alias x='exit'
alias lg='lazygit'

# eza (better ls)
alias l="eza --icons"
alias ls="eza --icons"
alias ll="eza -lg --icons"
alias la="eza -lag --icons"
alias lt="eza -lTg --icons"
alias lt1="eza -lTg --level=1 --icons"
alias lt2="eza -lTg --level=2 --icons"
alias lt3="eza -lTg --level=3 --icons"
alias lta="eza -lTag --icons"
alias lta1="eza -lTag --level=1 --icons"
alias lta2="eza -lTag --level=2 --icons"
alias lta3="eza -lTag --level=3 --icons"

# Command line services
alias weather='curl wttr.in'
alias cheat='~/scripts/cht.sh'
alias news='~/scripts/news.sh'
alias rss='newsboat'

EOF

echo "Setup Complete! Restart your terminal or run 'source ~/.bashrc'"
