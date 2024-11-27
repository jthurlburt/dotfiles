#!/usr/bin/env zsh

# Install pixi
curl -fsSL https://pixi.sh/install.sh | PIXI_VERSION=v0.38.0 bash

# Define the target directory for pixi global toml on macOS
PIXI_GLOBAL_TOML_DIR="${HOME}/.pixi/manifests"

# Check if pixi global toml directory exists
if [ -d "$PIXI_GLOBAL_TOML_DIR" ]; then
    # Copy your custom global toml to the pixi global toml directory
    ln -sf "${HOME}/dotfiles/settings/pixi-global.toml" "${PIXI_GLOBAL_TOML_DIR}/pixi-global.toml"

    ${HOME}/.pixi/bin/pixi global sync

    echo "pixi global toml has been installed."
else
    echo "pixi global toml directory does not exist. Please ensure pixi is installed."
fi
