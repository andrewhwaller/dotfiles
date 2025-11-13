#!/usr/bin/env bash
# Font installation script
# Can install fonts from USB, network location, or other mounted storage

set -e

echo "=== Font Installation ==="

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Check if a fonts directory is provided as argument
if [ -n "$1" ] && [ -d "$1" ]; then
  FONTS_SOURCE="$1"
  echo "Installing fonts from: $FONTS_SOURCE"

  # Copy all font files
  find "$FONTS_SOURCE" -type f \( -name "*.otf" -o -name "*.ttf" -o -name "*.woff" -o -name "*.woff2" \) -exec cp {} "$FONT_DIR/" \;

  # Update font cache
  fc-cache -f

  echo "✓ Fonts installed from $FONTS_SOURCE"
else
  echo "Usage: $0 <fonts-directory>"
  echo ""
  echo "Examples:"
  echo "  $0 /run/media/\$USER/USB/fonts"
  echo "  $0 /mnt/usb/TX-02"
  echo "  $0 ~/Downloads/fonts"
  echo ""
  echo "Expected font files in directory:"
  echo "  - TX-02 (*.otf, *.ttf)"
  echo "  - Nerd Fonts (Symbols Nerd Font Mono)"
  echo ""
  echo "Current fonts installed:"
  fc-list | grep -E "TX-02|Nerd" | cut -d: -f2 | sort -u || echo "  None found"
fi

echo ""
