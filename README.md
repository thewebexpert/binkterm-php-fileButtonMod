# Binkterm File Area Button & Directory Mod

A zero-touch, client-side plugin for [BinktermPHP](https://github.com/awehttam/binkterm-php) that adds **Quick Network Filters** and a full **Network Directory Landing View** to the Files page (`/files`), matching the look and feel of the Echo Area List (`/echolist`).

---

## Features

- **Zero-Touch & Upgrade-Proof**: Never touches or alters any core BinktermPHP templates or backend routes. Future `git pull upstream` updates merge cleanly without conflicts.
- **Dynamic Network Filter Buttons**:
  - Automatically discovers all connected networks from the active file areas (e.g. `ALL`, `LOCAL`, `TQWNET`, `FSXNET`, `LOVLYNET`).
  - Displays live area count badges on each button.
  - One-click instant filtering without page reloads.
- **Network Directory Landing View**:
  - Groups file areas into elegant category cards by network domain (`LOCAL`, `LOVLYNET`, `TQWNET`, `FSXNET`, etc.), matching `/echolist`.
  - Shows folder icon, area tag, description, total file count badge, total storage size badge, and capability tags (`FREQ`, `Gemini`, `Uploads`).
  - Replaces the default cramped 300px sidebar scrolling experience with an intuitive directory grid.
- **Seamless Navigation**:
  - Clicking any area card immediately opens that area's file table view.
  - Includes a prominent **"Back to Directory"** button to jump back to the network overview with one click.
  - View toggles for **Area Directory** vs **Recent Uploads**.
- **Theme-Integrated & Flash-Free**:
  - Automatically inherits button styling, fonts, and colors from your active BBS theme.
  - Transitions disabled to prevent Bootstrap default blue background/focus rings.

---

## Quick Install (1-Line Command)

Clone this repository and run the installer pointing to your Binkterm installation:

```bash
git clone https://github.com/thewebexpert/binkterm-php-fileButtonMod.git
cd binkterm-php-fileButtonMod
./install.sh /path/to/binkterm
```

*(If you are running the command from a directory adjacent to `binkterm`, `./install.sh` will auto-detect the `binkterm` directory).*

---

## Manual Installation

1. **Copy the JavaScript and CSS assets:**
   ```bash
   cp public_html/js/file-filter.js /path/to/binkterm/public_html/js/
   cp public_html/css/file-filter.css /path/to/binkterm/public_html/css/
   ```

2. **Add the assets to `templates/custom/header.insert.twig`:**
   Append the following to `/path/to/binkterm/templates/custom/header.insert.twig`:
   ```twig
   {# Binkterm File Area Button & Directory Mod #}
   <link rel="stylesheet" href="/css/file-filter.css?v=1.0">
   <script src="/js/file-filter.js?v=1.0" defer></script>
   ```

---

## Docker Compose Setup

If you run BinktermPHP in Docker, mount the plugin files into your container:

```yaml
services:
  binkterm-app:
    volumes:
      - ./plugins/binkterm-php-fileButtonMod/public_html/js/file-filter.js:/var/www/html/public_html/js/file-filter.js:ro
      - ./plugins/binkterm-php-fileButtonMod/public_html/css/file-filter.css:/var/www/html/public_html/css/file-filter.css:ro
```

---

## Uninstallation

To remove the plugin:

```bash
cd binkterm-php-fileButtonMod
./uninstall.sh /path/to/binkterm
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.
