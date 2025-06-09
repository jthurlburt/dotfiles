#!/usr/bin/env zsh

# Check if Homebrew's bin exists and if it's not already in the PATH
if [ -x "/opt/homebrew/bin/brew" ] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Install VS Code Extensions
extensions=(
    1password.op-vscode
    amodio.find-related
    charliermarsh.ruff
    databricks.databricks
    davidanson.vscode-markdownlint
    dvirtz.parquet-viewer
    eamodio.gitlens
    esbenp.prettier-vscode
    foxundermoon.shell-format
    github.copilot
    github.copilot-chat
    github.vscode-github-actions
    hashicorp.terraform
    jannisx11.batch-rename-extension
    mechatroner.rainbow-csv
    mhutchie.git-graph
    mineiros.terramate
    ms-azuretools.vscode-containers
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-toolsai.jupyter-keymap
    ms-toolsai.jupyter-renderers
    ms-toolsai.vscode-jupyter-cell-tags
    ms-toolsai.vscode-jupyter-slideshow
    ms-vscode-remote.remote-containers
    redhat.vscode-yaml
    samuelcolvin.jinjahtml
    tamasfe.even-better-toml
    tombonnike.vscode-status-bar-format-toggle
    wayou.vscode-todo-highlight
)

# Get a list of all currently installed extensions.
installed_extensions=$(code --list-extensions)

for extension in "${extensions[@]}"; do
    if echo "$installed_extensions" | grep -qi "^$extension$"; then
        echo "$extension is already installed. Skipping..."
    else
        echo "Installing $extension..."
        code --install-extension "$extension"
    fi
done

echo "VS Code extensions have been installed."

# Define the target directory for VS Code user settings on macOS
VSCODE_USER_SETTINGS_DIR="${HOME}/Library/Application Support/Code/User"

# Check if VS Code settings directory exists
if [ -d "$VSCODE_USER_SETTINGS_DIR" ]; then
    # Copy your custom settings.json and keybindings.json to the VS Code settings directory
    ln -sf "${HOME}/dotfiles/settings/VSCode-Settings.json" "${VSCODE_USER_SETTINGS_DIR}/settings.json"

    echo "VS Code settings have been updated."
else
    echo "VS Code user settings directory does not exist. Please ensure VS Code is installed."
fi

# Open VS Code to sign-in to extensions
code .
echo "Log in to extensions."
echo "Press enter to continue..."
read
