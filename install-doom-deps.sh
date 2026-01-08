#!/bin/bash
set -e

echo "=== Doom Emacs Dependencies Installer ==="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root. It will ask for sudo when needed."
    exit 1
fi

echo "This script will install all dependencies required for Doom Emacs."
echo "You may be prompted for your sudo password."
echo
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo

# Update package lists
echo "[1/6] Updating package lists..."
sudo apt update
print_status "Package lists updated"

# Core dependencies (REQUIRED)
echo
echo "[2/6] Installing core dependencies..."
sudo apt install -y \
    emacs \
    git \
    ripgrep \
    fd-find

print_status "Core dependencies installed"

# Build tools (for native compilation)
echo
echo "[3/6] Installing build tools for native compilation..."
sudo apt install -y \
    build-essential \
    cmake \
    libtool \
    libtool-bin

print_status "Build tools installed"

# Optional but recommended dependencies
echo
echo "[4/6] Installing recommended dependencies..."
sudo apt install -y \
    aspell \
    aspell-en \
    sqlite3 \
    libsqlite3-dev \
    pandoc \
    shellcheck \
    graphviz \
    gnuplot \
    imagemagick \
    libvterm-dev \
    libjansson-dev

print_status "Recommended dependencies installed"

# Fonts
echo
echo "[5/6] Installing fonts..."
sudo apt install -y \
    fonts-firacode \
    fonts-hack \
    fonts-dejavu

# Try to install JetBrains Mono if available
if apt-cache show fonts-jetbrains-mono &>/dev/null; then
    sudo apt install -y fonts-jetbrains-mono
    print_status "JetBrains Mono font installed"
else
    print_warning "JetBrains Mono not in repos, you can install it manually from: https://www.jetbrains.com/lp/mono/"
fi

print_status "Fonts installed"

# Verify installations
echo
echo "[6/6] Verifying installations..."
echo
echo "Installed versions:"
echo "-------------------"

check_version() {
    if command -v "$1" &>/dev/null; then
        VERSION=$($2 2>/dev/null | head -1)
        print_status "$1: $VERSION"
    else
        print_error "$1: NOT FOUND"
    fi
}

check_version "emacs" "emacs --version"
check_version "git" "git --version"
check_version "rg" "rg --version"
check_version "fdfind" "fdfind --version"
check_version "cmake" "cmake --version"
check_version "aspell" "aspell --version"
check_version "sqlite3" "sqlite3 --version"
check_version "pandoc" "pandoc --version"
check_version "shellcheck" "shellcheck --version"

echo
echo "=== All Dependencies Installed ==="
echo
echo "Next steps:"
echo "  1. Run ./install-doom-emacs.sh to install Doom Emacs"
echo "  2. Or manually:"
echo "     git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs"
echo "     ~/.config/emacs/bin/doom install"
echo
echo "Note: On Ubuntu/Debian, 'fd' is available as 'fdfind'."
echo "      Doom Emacs will detect this automatically."
