#!/usr/bin/env bash
# ==============================================================================
# Binkterm File Area Button & Directory Mod - Installer
# https://github.com/thewebexpert/binkterm-php-fileButtonMod
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$(cd "$SCRIPT_DIR/.." && pwd)}"

# If current directory is adjacent to binkterm root
if [ -d "$SCRIPT_DIR/public_html" ] && [ -d "$TARGET_DIR/binkterm" ]; then
    TARGET_DIR="$TARGET_DIR/binkterm"
fi

echo "======================================================"
echo " Installing Binkterm File Area Button & Directory Mod"
echo " Target Binkterm Directory: $TARGET_DIR"
echo "======================================================"

if [ ! -d "$TARGET_DIR/public_html" ] || [ ! -d "$TARGET_DIR/templates" ]; then
    echo "Error: Target directory does not look like a valid BinktermPHP installation."
    echo "Usage: ./install.sh /path/to/binkterm"
    exit 1
fi

# 1. Copy JavaScript asset
mkdir -p "$TARGET_DIR/public_html/js"
cp "$SCRIPT_DIR/public_html/js/file-filter.js" "$TARGET_DIR/public_html/js/file-filter.js"
echo "[✓] Installed public_html/js/file-filter.js"

# 2. Copy CSS asset
mkdir -p "$TARGET_DIR/public_html/css"
cp "$SCRIPT_DIR/public_html/css/file-filter.css" "$TARGET_DIR/public_html/css/file-filter.css"
echo "[✓] Installed public_html/css/file-filter.css"

# 3. Configure templates/custom/header.insert.twig
mkdir -p "$TARGET_DIR/templates/custom"
HEADER_INSERT="$TARGET_DIR/templates/custom/header.insert.twig"

if [ ! -f "$HEADER_INSERT" ]; then
    cp "$SCRIPT_DIR/templates/custom/header.insert.twig" "$HEADER_INSERT"
    echo "[✓] Created templates/custom/header.insert.twig"
else
    if grep -q "file-filter.js" "$HEADER_INSERT"; then
        echo "[✓] templates/custom/header.insert.twig already includes file-filter.js"
    else
        echo "" >> "$HEADER_INSERT"
        echo "{# Binkterm File Area Button & Directory Mod #}" >> "$HEADER_INSERT"
        echo '<link rel="stylesheet" href="/css/file-filter.css?v=1.0">' >> "$HEADER_INSERT"
        echo '<script src="/js/file-filter.js?v=1.0" defer></script>' >> "$HEADER_INSERT"
        echo "[✓] Appended file-filter assets to existing templates/custom/header.insert.twig"
    fi
fi

# 4. Docker live update (if binkterm-app container is running)
if command -v docker >/dev/null 2>&1 && docker ps --format '{{.Names}}' | grep -q "^binkterm-app$"; then
    echo "[*] Detected running binkterm-app container. Syncing assets..."
    docker cp "$SCRIPT_DIR/public_html/js/file-filter.js" binkterm-app:/var/www/html/public_html/js/file-filter.js
    docker cp "$SCRIPT_DIR/public_html/css/file-filter.css" binkterm-app:/var/www/html/public_html/css/file-filter.css
    docker cp "$HEADER_INSERT" binkterm-app:/var/www/html/templates/custom/header.insert.twig
    echo "[✓] Successfully synced to binkterm-app container"
fi

echo ""
echo "Installation complete! File Area Button & Directory Mod is now active on /files."
echo "======================================================"
