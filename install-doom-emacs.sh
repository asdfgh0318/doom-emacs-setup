#!/bin/bash
set -e

echo "=== Doom Emacs Installation Script ==="
echo

# Step 1: Install dependencies
echo "[1/4] Installing Emacs and dependencies..."
sudo apt update
sudo apt install -y emacs fd-find

# Verify Emacs version
EMACS_VERSION=$(emacs --version | head -1)
echo "Installed: $EMACS_VERSION"

# Step 2: Backup existing Emacs config if present
if [ -d "$HOME/.config/emacs" ]; then
    echo "[2/4] Backing up existing ~/.config/emacs to ~/.config/emacs.bak..."
    mv "$HOME/.config/emacs" "$HOME/.config/emacs.bak"
elif [ -d "$HOME/.emacs.d" ]; then
    echo "[2/4] Backing up existing ~/.emacs.d to ~/.emacs.d.bak..."
    mv "$HOME/.emacs.d" "$HOME/.emacs.d.bak"
else
    echo "[2/4] No existing Emacs config found, skipping backup."
fi

# Step 3: Clone Doom Emacs
echo "[3/4] Cloning Doom Emacs..."
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs

# Step 4: Add doom to PATH in shell config
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q 'emacs/bin' "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo '# Doom Emacs' >> "$SHELL_RC"
        echo 'export PATH="$HOME/.config/emacs/bin:$PATH"' >> "$SHELL_RC"
        echo "[4/4] Added Doom to PATH in $SHELL_RC"
    else
        echo "[4/4] Doom PATH already configured in $SHELL_RC"
    fi
else
    echo "[4/4] No .bashrc or .zshrc found. Add this to your shell config manually:"
    echo '    export PATH="$HOME/.config/emacs/bin:$PATH"'
fi

# Step 5: Run Doom install
echo
echo "=== Running Doom installer ==="
echo "This will install packages and build configuration."
echo
~/.config/emacs/bin/doom install

echo
echo "=== Installation Complete ==="
echo "Restart your terminal or run: source $SHELL_RC"
echo "Then run 'emacs' to start Doom Emacs!"
