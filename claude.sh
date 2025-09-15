#!/usr/bin/env zsh

# Claude Configuration Script
echo "Setting up Claude configuration..."

# Define source and target paths
DOTFILES_DIR="${HOME}/dotfiles"
CLAUDE_SETTINGS_DIR="${DOTFILES_DIR}/settings/claude"

# Claude Desktop configuration
CLAUDE_DESKTOP_CONFIG_TARGET="${HOME}/Library/Application Support/Claude"
CLAUDE_DESKTOP_CONFIG_FILE="claude_desktop_config.json"

# Claude Code settings
CLAUDE_CODE_SETTINGS_TARGET="${HOME}/.claude"
CLAUDE_CODE_SETTINGS_FILE="settings.json"
CLAUDE_CODE_INSTRUCTIONS_FILE="code.md"

# VSCode Copilot instructions
VSCODE_COPILOT_TARGET="${HOME}/Library/Application Support/Code/User/prompts"
VSCODE_COPILOT_FILE="copilot.md"

# Create target directories if they don't exist
echo "Creating target directories..."
mkdir -p "${CLAUDE_DESKTOP_CONFIG_TARGET}"
mkdir -p "${CLAUDE_CODE_SETTINGS_TARGET}"
mkdir -p "${VSCODE_COPILOT_TARGET}"

# Check if source files exist
if [ ! -d "${CLAUDE_SETTINGS_DIR}" ]; then
    echo "Claude settings directory not found at ${CLAUDE_SETTINGS_DIR}"
    exit 1
fi

# Claude Desktop configuration
if [ -f "${CLAUDE_SETTINGS_DIR}/${CLAUDE_DESKTOP_CONFIG_FILE}" ]; then
    echo "Linking Claude Desktop configuration..."
    ln -sf "${CLAUDE_SETTINGS_DIR}/${CLAUDE_DESKTOP_CONFIG_FILE}" "${CLAUDE_DESKTOP_CONFIG_TARGET}/${CLAUDE_DESKTOP_CONFIG_FILE}"
    echo "Claude Desktop configuration linked successfully."
else
    echo "Warning: ${CLAUDE_DESKTOP_CONFIG_FILE} not found in settings directory."
fi

# Claude Code settings
if [ -f "${CLAUDE_SETTINGS_DIR}/${CLAUDE_CODE_SETTINGS_FILE}" ]; then
    echo "Linking Claude Code settings..."
    ln -sf "${CLAUDE_SETTINGS_DIR}/${CLAUDE_CODE_SETTINGS_FILE}" "${CLAUDE_CODE_SETTINGS_TARGET}/${CLAUDE_CODE_SETTINGS_FILE}"
    echo "Claude Code settings linked successfully."
else
    echo "Warning: ${CLAUDE_CODE_SETTINGS_FILE} not found in settings directory."
fi

# Claude Code instructions (code.md -> CLAUDE.md)
if [ -f "${CLAUDE_SETTINGS_DIR}/${CLAUDE_CODE_INSTRUCTIONS_FILE}" ]; then
    echo "Linking Claude Code instructions..."
    ln -sf "${CLAUDE_SETTINGS_DIR}/${CLAUDE_CODE_INSTRUCTIONS_FILE}" "${CLAUDE_CODE_SETTINGS_TARGET}/CLAUDE.md"
    echo "Claude Code instructions linked successfully."
else
    echo "Warning: ${CLAUDE_CODE_INSTRUCTIONS_FILE} not found in settings directory."
fi

# VSCode Copilot instructions
if [ -f "${CLAUDE_SETTINGS_DIR}/${VSCODE_COPILOT_FILE}" ]; then
    echo "Linking VSCode Copilot instructions..."
    ln -sf "${CLAUDE_SETTINGS_DIR}/${VSCODE_COPILOT_FILE}" "${VSCODE_COPILOT_TARGET}/.instructions.md"
    echo "VSCode Copilot instructions linked successfully."
else
    echo "Warning: ${VSCODE_COPILOT_FILE} not found in settings directory."
fi

echo "Claude configuration setup complete!"
