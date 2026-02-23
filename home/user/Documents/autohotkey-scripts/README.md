# autohotkey-scripts

Personal AutoHotkey v2 scripts for Windows.

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/)
- [VD.ah2](https://github.com/FuPeiJiang/VD.ahk/tree/v2_port) — place in the same folder as `quake.ahk`

## quake.ahk

| Shortcut | Action |
|---|---|
| `Alt+Z` | Toggle Windows Terminal quake mode |
| `Alt+N` | Type ñ |
| `Ctrl+Shift+Win+Left` | Move active window to previous virtual desktop |
| `Ctrl+Shift+Win+Right` | Move active window to next virtual desktop |

## Setup

1. Clone or download this repo
2. Download `VD.ah2` from the link above and place it in the same folder
3. Run `quake.ahk` with AutoHotkey v2
4. To run on startup, add this to `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`:
   ```
   "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" "path\to\quake.ahk"
   ```
