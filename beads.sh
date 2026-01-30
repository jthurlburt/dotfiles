#!/usr/bin/env zsh

# Beads Configuration Script
# Sets up global beads issue tracker at ~/.beads/
echo "Setting up Beads configuration..."

BEADS_DIR="${HOME}/.beads"
BEADS_DB="${BEADS_DIR}/global.db"

# Create beads directory if it doesn't exist
if [ ! -d "${BEADS_DIR}" ]; then
    echo "Creating ${BEADS_DIR}..."
    mkdir -p "${BEADS_DIR}"
fi

# Initialize global beads database if it doesn't exist
if [ ! -f "${BEADS_DB}" ]; then
    echo "Initializing global beads database..."

    # Check if bd is installed
    if ! command -v bd &> /dev/null; then
        echo "Error: bd command not found. Install beads first:"
        echo "  cargo install beads"
        exit 1
    fi

    # Initialize with global prefix (run from temp dir to avoid git repo detection)
    cd /tmp
    BD_DB="${BEADS_DB}" bd init --prefix global
    cd - > /dev/null

    echo "Global beads database initialized at ${BEADS_DB}"
else
    echo "Beads database already exists at ${BEADS_DB}"
fi

# Verify env vars are set (should be in .zshrc)
echo ""
echo "Checking environment variables..."
if [ -z "${BD_DB}" ]; then
    echo "Warning: BD_DB not set. Add to .zshrc:"
    echo '  export BD_DB="$HOME/.beads/global.db"'
    echo '  export BD_NO_DAEMON=1'
else
    echo "BD_DB=${BD_DB}"
    echo "BD_NO_DAEMON=${BD_NO_DAEMON:-not set}"
fi

echo ""
echo "Beads configuration complete!"
