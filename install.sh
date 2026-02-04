set -e

brew tap browsh-org/homebrew-browsh
brew install nvim tmux gnupg stow fzf zoxide starship zsh-autosuggestions zsh-syntax-highlighting eza tmuxp ripgrep w3m browsh newsboat

brew install --cask wezterm

brew install aerc

brew tap d99kris/nchat
brew install nchat

mkdir ~/.config/wezterm
mkdir ~/.newsboat
mkdir ~/.config/tmux 
mkdir ~/.config/nvim 

mkdir ~/scripts
find ./scripts -name "*.sh" -exec chmod +x {} +

stow -t ~ zsh
stow -t ~/.config/nvim nvim
stow -t ~/.config/wezterm wezterm
stow -t ~/.newsboat newsboat
stow -t ~/scripts scripts
stow -t ~/.config/tmux tmux



source ~/.zshrc
