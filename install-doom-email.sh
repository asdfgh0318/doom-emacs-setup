#!/bin/bash
set -e

echo "=== Doom Emacs Email Dependencies ==="
echo

# Install mu4e dependencies
echo "[1/3] Installing email tools..."
sudo apt update
sudo apt install -y \
    isync \
    msmtp \
    msmtp-mta \
    mu4e \
    maildir-utils

echo
echo "[2/3] Initializing mu database..."
mkdir -p ~/Mail/Gmail
mu init --maildir=~/Mail --my-address=hamper100@gmail.com
mu index

echo
echo "[3/3] Setup complete!"
echo
echo "=== IMPORTANT: Gmail App Password Setup ==="
echo
echo "1. Go to: https://myaccount.google.com/apppasswords"
echo "2. Generate an App Password for 'Mail'"
echo "3. Save the password to ~/.gmail-password:"
echo "   echo 'YOUR_APP_PASSWORD' > ~/.gmail-password"
echo "   chmod 600 ~/.gmail-password"
echo
echo "4. Enable IMAP in Gmail settings:"
echo "   Settings > See all settings > Forwarding and POP/IMAP > Enable IMAP"
echo
echo "5. Sync your mail:"
echo "   mbsync -a"
echo
echo "6. In Emacs, press SPC o m to open mu4e"
