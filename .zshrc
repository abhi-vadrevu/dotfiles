# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# User configuration
source ~/.bashrc

# Starship.rs
eval "$(starship init zsh)"

# Autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
