# ender4-dots — Windows

Personal Windows dotfiles. This branch contains configuration for the Windows desktop environment only.

## Showcase

![Desktop overview](https://i.imgur.com/KAikG2F.png)
![YASB bar](https://i.imgur.com/UpSq95u.png)
![Neovim](https://i.imgur.com/APgbrPl.png)
![Windows Terminal](https://i.imgur.com/gR7DBLp.png)

<sub>AI Chat panel — work in progress</sub>

![AI Chat panel](https://i.imgur.com/VAHQQAz.png)

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

[Windows Terminal Preview](https://github.com/microsoft/terminal) by Microsoft. The Preview build receives features earlier than the stable release.

Terminal configuration with:

- Font: IosevkaTerm Nerd Font, size 16
- Theme: One Half Dark (custom dark variant with near-black background `#0A0B0D`)
- Acrylic background with 90% opacity
- Default profile: Windows PowerShell

**Quake mode:** Press `Win+`` to toggle a drop-down terminal that slides from the top of the screen. Mapped to `Alt+Z` via AutoHotkey (see below).

**Install location:** `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json`

---

### WezTerm — `home/.wezterm.lua`

[WezTerm](https://wezfurlong.org/wezterm/) by wez. GPU-accelerated terminal emulator with Lua configuration. Used as the primary terminal on Windows.

- Font: IosevkaTerm Nerd Font, size 19
- Background: Acrylic transparency (`win32_system_backdrop = "Acrylic"`, 80% opacity)
- Color palette: Gentleman theme (custom dark palette matching ghostty config)
- Default shell: `powershell.exe`
- Max FPS: 240, Kitty graphics protocol enabled

**Install location:** `%USERPROFILE%\.wezterm.lua`

```powershell
winget install wez.wezterm
```

---

### Nushell

[Nushell](https://www.nushell.sh/) by the Nushell contributors. A modern shell that treats all data as structured — commands return tables, lists, and records instead of plain text. Pairs well with Starship for a fully customized shell experience on Windows.

```powershell
winget install Nushell.Nushell
```

---

### Starship — `.config/starship/starship.toml`

[Starship](https://starship.rs/) by starship-rs contributors. Minimal, fast, cross-shell prompt written in Rust.

Prompt layout:

```
~/path/to/dir               ⚡ 🐍  14:32
👾 ➜
```

- Left: current directory in matrix green (`#00ff41`)
- Right: tech stack icons (auto-detected per project), command duration (if >2s), clock in gray
- Character: `👾 ➜` in magenta (`#ce08ff`) — red on error
- Tech detection: Node ⚡, Python 🐍, Rust 🦀, Go 🐹, PHP 🐘, Java ☕, C/C++ ⚙️, Ruby 💎, Docker 🐳

**Install:**

```powershell
choco install starship
```

**Config location:** `%USERPROFILE%\.config\starship.toml`

Add to PowerShell profile (`$PROFILE`):

```powershell
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)
```

---

### Float Tools

Tools used as floating overlays or quick-access utilities on top of the desktop.

#### Windows Terminal Preview — Quake Mode

Windows Terminal Preview includes a built-in quake/drop-down mode. Press `Win+`` (or `Alt+Z` via AutoHotkey) to toggle a terminal that slides down from the top of the screen, stays on top of all windows, and hides when dismissed. No third-party software required.

#### WTQ — WezTerm Quake Mode

[WTQ](https://github.com/flyingpie/windows-terminal-quake) by flyingpie. Brings quake-style drop-down terminal support to any terminal emulator on Windows, including WezTerm. Attach it to an existing WezTerm window and toggle it with a global hotkey.

```powershell
winget install flyingpie.windows-terminal-quake
```

Configure in `wtq.json` to target WezTerm and bind your preferred toggle key.

#### Flow Launcher

[Flow Launcher](https://www.flowlauncher.com/) by jjw24 and contributors. Application launcher and search utility for Windows, similar to Raycast on macOS. Supports plugins, custom themes, and hotkey activation.

Extensions used:

| Plugin | Description | Source |
|--------|-------------|--------|
| Everything | Fast file search via Everything engine | [community plugins](https://github.com/Flow-Launcher/Flow.Launcher.Plugin.Everything) |
| TodoList | Quick task capture and management | [community plugins](https://github.com/Flow-Launcher/Flow.Launcher.Community.Plugin.TodoList) |
| Google Search | Open Google searches instantly | built-in |
| DeepL Translate | Translate selected text via DeepL API | [community plugins](https://github.com/nvs-abhilash/Flow.Launcher.Plugin.DeepLTranslate) |
| GIF Search | Search and copy GIFs via Tenor | [community plugins](https://github.com/riojano0/flowlauncher-gif-finder) |

#### Open-LLM-VTuber

[Open-LLM-VTuber](https://github.com/Open-LLM-VTuber/Open-LLM-VTuber) by Open-LLM-VTuber contributors. Voice-interactive AI VTuber companion with a Live2D avatar that runs entirely locally. Supports all major LLMs, TTS, and ASR backends. Used here as York — an always-on AI companion that floats over the desktop with a Live2D avatar, responds to voice, and provides conversational AI assistance.

The Live2D model used for York is the [Deadbeat VTuber Model (Free)](https://jawlipops.gumroad.com/l/XBsYK) by [jawli](https://jawlipops.gumroad.com/), which gives York her expressiveness and personality.

#### Spicetify

[Spicetify](https://spicetify.app/) by spicetify. CLI tool to customize the Spotify desktop client — themes, extensions, and custom apps injected directly into the client.

```powershell
winget install Spicetify.Spicetify
```

After install, apply a theme and restart Spotify:

```powershell
spicetify config current_theme <theme-name>
spicetify apply
```

---

### Tacky Borders — `home/user/.config/tacky-borders/`

Window border highlighting via [tacky-borders](https://github.com/lukeyou05/tacky-borders).

- Active window: animated purple → violet → green gradient border (`ReverseSpiral` + `Fade`)
- Inactive windows: no border (transparent)
- Auto-reloads on config change (`watch_config_changes: true`)

**Install location:** `%USERPROFILE%\.config\tacky-borders\`

---

### YASB — `home/user/AppData/Roaming/yasb/`

Status bar configuration for [YASB](https://github.com/amnweb/yasb) using the Fluent Onyx v2 theme.

Bar layout:

| Left | Center | Right |
|------|--------|-------|
| AI Chat, Virtual desktops, Media player, Cava visualizer | — | CPU usage, GPU temperature, App launchers |

Widgets configured (not all active by default):

- `ai_chat` — AI chat popup supporting multiple providers; configured with GitHub Copilot and Gemini 2.5 Flash (via OpenAI-compatible Google AI Studio endpoint)
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
  starship/
    starship.toml        Starship prompt config
  tacky-borders/
    config.yaml          Tacky Borders window border config
home/
  .wezterm.lua           WezTerm terminal config
  user/
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

---

## Acknowledgments

- [Open-LLM-VTuber](https://github.com/Open-LLM-VTuber/Open-LLM-VTuber) - Voice-interactive AI VTuber companion with Live2D support (York's engine)
- [Deadbeat VTuber Model](https://jawlipops.gumroad.com/l/XBsYK) by jawli - Live2D model that gives York her expressiveness and personality
- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration framework
- [YASB](https://github.com/amnweb/yasb) - Windows status bar
- [Flow Launcher](https://www.flowlauncher.com/) - Application launcher
- [Spicetify](https://spicetify.app/) - Spotify client customization
- [AutoHotkey](https://www.autohotkey.com/) - Windows automation scripting
- [WezTerm](https://wezfurlong.org/wezterm/) - GPU-accelerated terminal emulator
- [Nushell](https://www.nushell.sh/) - Modern structured data shell
- [Starship](https://starship.rs/) - Minimal cross-shell prompt
- [WTQ](https://github.com/flyingpie/windows-terminal-quake) - Quake-style drop-down mode for any terminal
