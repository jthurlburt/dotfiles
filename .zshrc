###############################################################################
# Oh My Zsh Settings
###############################################################################

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

plugins=(aliases command-not-found copyfile copypath dotenv git history)

source $ZSH/oh-my-zsh.sh

###############################################################################
# PATH Updates
###############################################################################

# Add pixi to the path
export PATH="$HOME/.pixi/bin:$PATH"

# Add local bin to the path
export PATH="$HOME/.local/bin:$PATH"

# Add cargo bin to the path
export PATH="$HOME/.cargo/bin:$PATH"

###############################################################################
# Autocompletion Settings
###############################################################################

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# uv
eval "$(uv generate-shell-completion zsh)"

# pixi
eval "$(pixi completion --shell zsh)"

# Terraform
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Terramate
complete -o nospace -C /opt/homebrew/bin/terramate terramate

# Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

###############################################################################
# Terramate Settings
###############################################################################
export TM_DISABLE_SAFEGUARDS=git-untracked,git-uncommitted,git-out-of-sync

###############################################################################
# dbt Settings
###############################################################################
export DBT_PROFILES_DIR="$HOME/.dbt"

###############################################################################
# Beads (global issue tracker)
###############################################################################
export BD_DB="$HOME/.beads/global.db"

###############################################################################
# Dotfiles
###############################################################################
for file in ~/.{aliases,private}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
