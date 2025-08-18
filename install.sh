set -e

brew install nvim tmux gnupg stow fzf zoxide

stow -t ~ zsh

stow -t ~/.config .config

source ~/.zshrc
