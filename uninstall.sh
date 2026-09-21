#!/usr/bin/env bash
# ==============================================================================
# Binkterm File Area Button & Directory Mod - Uninstaller
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
echo " Uninstalling Binkterm File Area Button & Directory Mod"
echo " Target Binkterm Directory: $TARGET_DIR"
echo "======================================================"

# 1. Remove JavaScript & CSS assets
if [ -f "$TARGET_DIR/public_html/js/file-filter.js" ]; then
    rm -f "$TARGET_DIR/public_html/js/file-filter.js"
    echo "[✓] Removed public_html/js/file-filter.js"
fi
if [ -f "$TARGET_DIR/public_html/css/file-filter.css" ]; then
    rm -f "$TARGET_DIR/public_html/css/file-filter.css"
    echo "[✓] Removed public_html/css/file-filter.css"
fi

# 2. Remove from templates/custom/header.insert.twig
HEADER_INSERT="$TARGET_DIR/templates/custom/header.insert.twig"
if [ -f "$HEADER_INSERT" ]; then
    sed -i.bak '/file-filter\.js/d' "$HEADER_INSERT"
    sed -i.bak '/file-filter\.css/d' "$HEADER_INSERT"
    sed -i.bak '/Binkterm File Area Button & Directory Mod/d' "$HEADER_INSERT"
    rm -f "${HEADER_INSERT}.bak"
    echo "[✓] Removed file-filter references from templates/custom/header.insert.twig"
fi

# 3. Docker live removal (if binkterm-app container is running)
if command -v docker >/dev/null 2>&1 && docker ps --format '{{.Names}}' | grep -q "^binkterm-app$"; then
    echo "[*] Detected running binkterm-app container. Removing assets..."
    docker exec binkterm-app rm -f /var/www/html/public_html/js/file-filter.js /var/www/html/public_html/css/file-filter.css || true
    if [ -f "$HEADER_INSERT" ]; then
        docker cp "$HEADER_INSERT" binkterm-app:/var/www/html/templates/custom/header.insert.twig
    fi
    echo "[✓] Synced removal to binkterm-app container"
fi

echo ""
echo "Uninstallation complete."
echo "======================================================"
