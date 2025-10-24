set -e

brew install nvim tmux gnupg stow fzf zoxide starship zsh-autosuggestions zsh-syntax-highlighting eza tmuxp ripgrep
brew install --cask wezterm

mkdir ~/.config/wezterm

stow -t ~ zsh
stow -t ~/.config .config
stow -t ~/.config/wezterm wezterm

source ~/.zshrc
