set -e

brew tap browsh-org/homebrew-browsh
brew install nvim tmux gnupg stow fzf zoxide starship zsh-autosuggestions zsh-syntax-highlighting eza tmuxp ripgrep w3m browsh newsboat

brew install --cask wezterm

mkdir ~/.config/wezterm
mkdir ~/.newsboat

stow -t ~ zsh
stow -t ~/.config .config
stow -t ~/.config/wezterm wezterm
stow -t ~/.newsboat newsboat

source ~/.zshrc
