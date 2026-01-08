#!/bin/bash
set -e

echo "=== Doom Emacs Extra Dependencies ==="
echo

# System packages via apt
echo "[1/3] Installing system packages..."
sudo apt update
sudo apt install -y \
    nodejs \
    npm \
    tidy \
    php \
    composer

# Python tools via pip
echo
echo "[2/3] Installing Python tools..."
sudo apt install -y python3-pip python3-venv

pip3 install --user --break-system-packages \
    isort \
    pytest \
    nose \
    pipenv \
    black \
    pyflakes

# NPM global packages
echo
echo "[3/3] Installing npm packages..."
sudo npm install -g \
    stylelint \
    js-beautify \
    typescript \
    typescript-language-server \
    vscode-langservers-extracted \
    prettier

echo
echo "=== Installation Complete ==="
echo
echo "Restart Emacs daemon to apply changes:"
echo "  emacsclient -e '(kill-emacs)' && /usr/bin/emacs --daemon"
echo
echo "Then run 'doom doctor' to verify:"
echo "  doom doctor"
