#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG_FILE="$SCRIPT_DIR/doom-emacs-manual.org"
PDF_FILE="$SCRIPT_DIR/doom-emacs-manual.pdf"

echo "=== Doom Emacs Manual PDF Generator ==="
echo

# Check if org file exists
if [ ! -f "$ORG_FILE" ]; then
    echo "Error: $ORG_FILE not found!"
    exit 1
fi

# Check for pandoc
if ! command -v pandoc &>/dev/null; then
    echo "Pandoc not found. Installing..."
    sudo apt install -y pandoc
fi

# Check for LaTeX
if ! command -v pdflatex &>/dev/null; then
    echo "LaTeX not found. Installing minimal texlive (this may take a few minutes)..."
    sudo apt install -y \
        texlive-latex-base \
        texlive-latex-recommended \
        texlive-fonts-recommended \
        texlive-latex-extra
fi

echo
echo "Converting org to PDF..."
pandoc "$ORG_FILE" \
    -f org \
    -o "$PDF_FILE" \
    --pdf-engine=pdflatex \
    -V geometry:margin=1in \
    -V fontsize=11pt \
    -V documentclass=article \
    --toc \
    --toc-depth=2 \
    -V colorlinks=true \
    -V linkcolor=blue \
    -V urlcolor=blue

if [ -f "$PDF_FILE" ]; then
    echo
    echo "Success! PDF created: $PDF_FILE"
    echo
    # Show file size
    ls -lh "$PDF_FILE"
else
    echo "Error: PDF generation failed"
    exit 1
fi
