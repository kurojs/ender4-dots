# ender4-dots — Windows

Personal Windows dotfiles. This branch contains configuration for the Windows desktop environment only.

## Showcase

![Desktop overview](https://i.imgur.com/KAikG2F.png)
![YASB bar](https://i.imgur.com/UpSq95u.png)
![Neovim](https://i.imgur.com/APgbrPl.png)
![Windows Terminal](https://i.imgur.com/gR7DBLp.png)

---

## Contents

### Neovim — `.config/nvim-windows/`

Windows-adapted Neovim configuration based on [LazyVim](https://lazyvim.org). Adapted from the Linux setup with the following changes:

- Node.js detection uses `PATH` lookup first, with fallback to common Windows install paths
- tmux navigation plugin disabled (no tmux on Windows)
- Obsidian plugin disabled (no vault configured on Windows)
- `opencode.nvim` set as the active AI plugin, using `opencode` from `PATH`
- Dashboard header uses the KURO ASCII art

**Install location:** `%LOCALAPPDATA%\nvim`

**Dependencies:** `nvim`, `ripgrep`, `fd`, `lazygit`, `make`, `node` (v18+), `tree-sitter-cli`

```
winget install Neovim.Neovim BurntSushi.ripgrep.MSVC sharkdp.fd JesseDuffield.lazygit GnuWin32.Make OpenJS.NodeJS
npm install -g tree-sitter-cli
```

---

### Windows Terminal Preview — `home/user/AppData/Local/Microsoft/Windows Terminal Preview/`

Terminal configuration with:

- Font: IosevkaTerm Nerd Font, size 16
- Theme: One Half Dark (custom dark variant with near-black background `#0A0B0D`)
- Acrylic background with 90% opacity
- Default profile: Windows PowerShell

**Install location:** `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json`

---

### YASB — `home/user/AppData/Roaming/yasb/`

Status bar configuration for [YASB](https://github.com/amnweb/yasb) using the Fluent Onyx v2 theme.

Bar layout:

| Left | Center | Right |
|------|--------|-------|
| Virtual desktops, Media player, Cava visualizer | — | CPU usage, GPU temperature, App launchers |

Widgets configured (not all active by default):

- `windows_workspaces` — virtual desktop switcher
- `media` — current playing track with popup media menu
- `cava` — audio visualizer (mirrored bars, purple gradient)
- `cpu` — CPU usage percentage with histogram
- `gpu` — GPU temperature and VRAM usage
- `memory` — RAM and swap usage
- `clock` — date/time with calendar popup
- `volume` — system volume with audio device menu
- `microphone` — microphone level and mute toggle
- `traffic` — network upload/download speed
- `disk` — disk usage grouped by drive letter
- `apps` — quick launch icons (Windows Update, Task Manager, Terminal, VS Code, Steam)
- `power_menu` — lock, sign out, shutdown, restart, hibernate

Style uses Windows 11 Fluent design tokens — dark acrylic background, Segoe UI Variable typography, system accent color.

**Install location:** `%APPDATA%\yasb\`

**Scripts:**

- `scripts/fix_winaero.ps1` — fixes WinAero Tweaker compatibility
- `scripts/last_commit.ps1` — displays last git commit info as a widget label

---

### AutoHotkey Scripts — `home/user/Documents/autohotkey-scripts/`

AutoHotkey v2 scripts for Windows keybindings.

**Requires:** [AutoHotkey v2](https://www.autohotkey.com/), [VD.ah2](https://github.com/FuPeiJiang/VD.ah2)

**`quake.ahk`**

| Shortcut | Action |
|----------|--------|
| `Alt+Z` | Toggle Windows Terminal quake mode (`Win+`\`) |
| `Alt+N` | Type `ñ` |
| `Ctrl+Shift+Win+Left` | Move active window to previous virtual desktop |
| `Ctrl+Shift+Win+Right` | Move active window to next virtual desktop |

---

## Structure

```
.config/
  nvim-windows/          Neovim config (Windows)
home/user/
  AppData/
    Local/
      Microsoft/
        Windows Terminal Preview/
          settings.json  Windows Terminal Preview config
    Roaming/
      yasb/
        config.yaml      YASB bar config
        styles.css       YASB stylesheet (Fluent Onyx v2)
        scripts/         Helper PowerShell scripts
  Documents/
    autohotkey-scripts/
      quake.ahk          AutoHotkey v2 keybindings
```
