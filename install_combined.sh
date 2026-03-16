#!/bin/bash
set -e

# ─────────────────────────────────────────
# Detect OS
# ─────────────────────────────────────────
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ -f /etc/arch-release ]]; then
    OS="manjaro"
fi

echo "Detected OS: $OS"

# ─────────────────────────────────────────
# macOS Setup
# ─────────────────────────────────────────
if [[ "$OS" == "macos" ]]; then

    # Install Homebrew if missing
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "Installing packages..."
    brew tap browsh-org/homebrew-browsh
    brew tap d99kris/nchat

    brew install \
        nvim tmux gnupg stow fzf zoxide starship \
        zsh-autosuggestions zsh-syntax-highlighting \
        eza tmuxp ripgrep w3m browsh newsboat aerc \
        calcurse ltex-ls pinentry-mac git-crypt \
        lazygit yazi ffmpeg-full sevenzip jq poppler \
        fd resvg imagemagick-full nchat caddy cloudflared yt-dlp

    brew install --cask wezterm
    brew install --cask font-symbols-only-nerd-font

    # GPG pinentry
    mkdir -p ~/.gnupg
    echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
    echo "use-standard-socket" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill all

    # Create config directories
    mkdir -p ~/.config/wezterm
    mkdir -p ~/.config/aerc
    mkdir -p ~/.newsboat
    mkdir -p ~/.config/tmux
    mkdir -p ~/.config/nvim
    mkdir -p ~/scripts
    mkdir -p ~/.config/yazi

    # Fix script permissions
    find ./scripts -name "*.sh" -exec chmod +x {} +

    # Stow dotfiles
    echo "Stowing dotfiles..."
    stow -t ~ zsh
    stow -t ~/.config/nvim nvim
    stow -t ~/.config/aerc aerc
    stow -t ~/.config/wezterm wezterm
    stow -t ~/.newsboat newsboat
    stow -t ~/scripts scripts
    stow -t ~/.config/tmux tmux
    stow -t ~/.config/yazi yazi

    # Unlock git-crypt (requires GPG key to be imported first)
    if command -v git-crypt &> /dev/null; then
        echo "Unlocking git-crypt..."
        git-crypt unlock || echo "Warning: git-crypt unlock failed. Import your GPG key first."
    fi

    source ~/.zshrc
    echo "macOS setup complete!"

# ─────────────────────────────────────────
# Manjaro / Arch Setup
# ─────────────────────────────────────────
elif [[ "$OS" == "manjaro" ]]; then

    echo "Updating system..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm base-devel git

    # Install yay if missing
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
    fi

    echo "Installing core packages..."
    sudo pacman -S --needed --noconfirm \
        neovim tmux gnupg stow fzf zoxide starship \
        eza tmuxp ripgrep w3m newsboat \
        wezterm nvm lazygit git-crypt \
        calcurse jq fd imagemagick \
        zsh zsh-autosuggestions zsh-syntax-highlighting \
        aerc caddy cloudflared

    echo "Installing AUR packages..."
    yay -S --needed --noconfirm \
        browsh-bin \
        ltex-ls-bin \
        yazi \
        nchat \
        pinentry

    # GPG pinentry for terminal
    mkdir -p ~/.gnupg
    echo "pinentry-program /usr/bin/pinentry-curses" > ~/.gnupg/gpg-agent.conf
    gpgconf --kill all

    # Create config directories
    mkdir -p ~/.config/wezterm
    mkdir -p ~/.config/aerc
    mkdir -p ~/.newsboat
    mkdir -p ~/.config/tmux
    mkdir -p ~/.config/nvim
    mkdir -p ~/scripts
    mkdir -p ~/.nvm

    # Fix script permissions
    if [ -d "./scripts" ]; then
        find ./scripts -name "*.sh" -exec chmod +x {} +
    fi

    # Stow dotfiles
    echo "Stowing dotfiles..."
    stow -t ~ zsh
    stow -t ~/.config/nvim nvim
    stow -t ~/.config/aerc aerc
    stow -t ~/.config/wezterm wezterm
    stow -t ~/.newsboat newsboat
    stow -t ~/scripts scripts
    stow -t ~/.config/tmux tmux

    # Unlock git-crypt
    if command -v git-crypt &> /dev/null; then
        echo "Unlocking git-crypt..."
        git-crypt unlock || echo "Warning: git-crypt unlock failed. Import your GPG key first."
    fi

    source ~/.zshrc
    echo "Manjaro setup complete!"

else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo ""
echo "────────────────────────────────────────"
echo "Setup complete!"
echo "Next steps:"
echo "  1. Import GPG keys: gpg --import ~/personal-private.asc"
echo "  2. Run: git-crypt unlock"
echo "  3. Restart terminal"
echo "────────────────────────────────────────"
