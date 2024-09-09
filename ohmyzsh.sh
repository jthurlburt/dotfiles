#!/usr/bin/env zsh

# Install Oh My Zsh if it isn't already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh not installed. Installing Oh My Zsh."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi
