# Ender4.Dots

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-6e40c9?logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-6e40c9?logo=wayland&logoColor=white)](https://hyprland.org/)
[![KDE](https://img.shields.io/badge/KDE-6e40c9?logo=kde&logoColor=white)](https://kde.org/)
[![Neovim](https://img.shields.io/badge/Neovim-6e40c9?logo=neovim&logoColor=white)](https://neovim.io/)
[![QuickShell](https://img.shields.io/badge/QuickShell-6e40c9?logo=qt&logoColor=white)](https://quickshell.org/)
[![Fish](https://img.shields.io/badge/Fish-6e40c9?logo=fish&logoColor=white)](https://fishshell.com/)
[![Ghostty](https://img.shields.io/badge/ghostty-6e40c9)](https://github.com/ghostty-org/ghostty)
[![License: MIT](https://img.shields.io/badge/License-MIT-6e40c9)](https://opensource.org/licenses/MIT)

> Ender4.Dots – Complete AI-Enhanced Desktop Environment for Arch Linux

Ender4.Dots is a comprehensive collection of dotfiles featuring a modern Hyprland-based desktop environment with integrated AI capabilities and advanced KDE window management. Built for advanced users who demand productivity, customization, and cutting-edge technology in their daily workflow. From intelligent code editing with multiple AI providers to voice-controlled music playback, this configuration brings together automation, multimedia control, and smart scripting in a unified, highly optimized environment.

---

## 📦 Table of Contents

1. [Features](#features)
2. [Architecture](#architecture)
3. [Requirements](#requirements)
4. [Installation](#installation)
   - [Automated Installation](#automated-installation)
   - [Manual Installation](#manual-installation)
5. [Configuration](#configuration)
6. [KDE Window Management](#kde-window-management)
7. [AI Integration](#ai-integration)
8. [Usage](#usage)
9. [Troubleshooting](#troubleshooting)
10. [Contributing](#contributing)
11. [Acknowledgments](#acknowledgments)

---

## 👾 Features

### Desktop Environment
- **Hyprland Compositor**: Modern Wayland compositor with advanced window management
- **QuickShell Interface**: Custom QML-based desktop shell with intelligent widgets
- **KDE Integration**: Advanced window rules and Krohnkite tiling for enhanced productivity
- **Dynamic Theming**: Material Design color schemes with automatic wallpaper integration
- **Custom Scripts**: Extensive automation for workspace management and system control

### Window Management
- **KWin Rules**: Comprehensive window management with custom rules for all applications
- **Krohnkite Tiling**: Advanced tiling window manager for KDE with intelligent layouts
- **Application Exclusions**: Smart exclusions for apps that shouldn't be tiled
- **Multi-Monitor Setup**: Optimized rules for multi-display configurations

### AI-Powered Workflow
- **Multiple AI Providers**: Claude, OpenAI, Gemini, Ollama integration
- **Voice Control**: Real-time voice synthesis and command execution
- **Intelligent Code Editing**: Advanced AI assistance in Neovim
- **Smart Translation**: Built-in translation with multiple backends

### Development Environment
- **Neovim Configuration**: LazyVim-based setup with AI plugins
- **Terminal Excellence**: Ghostty with Fish shell and smart completions
- **Code Assistance**: Avante, CodeCompanion, Copilot integration
- **Debug Tools**: Advanced debugging and development utilities

### Multimedia & Productivity
- **Spotify Integration**: Advanced music control and playlist management
- **Media Handling**: MPV, yt-dlp optimized playback
- **Task Management**: Integrated TODO system with calendar
- **Resource monitoring**: System metrics and performance widgets

---

## 🧰 Architecture

```plaintext
Ender4.Dots/
├── .config/
│   ├── hypr/                   # Hyprland configuration
│   │   ├── hyprland.conf       # Main compositor config
│   │   ├── custom/             # Custom configurations
│   │   ├── scripts/            # Automation scripts
│   │   └── shaders/            # Visual effects
│   ├── kwinrc                  # KWin configuration & Krohnkite settings
│   ├── kwinrulesrc             # Window rules and application behavior
│   ├── nvim/                   # Complete Neovim setup
│   │   ├── lua/config/         # Core configurations
│   │   └── lua/plugins/        # AI and editing plugins
│   ├── quickshell/ii/          # Custom desktop interface
│   │   ├── modules/            # UI components
│   │   ├── services/           # Backend services
│   │   └── scripts/            # Helper utilities
│   ├── fish/                   # Fish shell configuration
│   ├── ghostty/                # Terminal configuration
│   └── zed/                    # Alternative editor setup
├── .local/bin/                 # Custom executables
├── scripts/                    # Installation utilities
├── Docs/                       # Documentation
│   ├── AI.md                   # AI integration guide
│   └── SPOTIFY.md              # Music setup guide
├── install.sh                  # Automated installer
└── README.md                   # This file
```

---

## 🛠 Requirements

### System Dependencies

- **Core**: `hyprland`, `waybar`, `dunst`, `rofi-wayland`
- **KDE Components**: `kwin`, `krohnkite` (from AUR)
- **Terminal**: `ghostty`, `fish`, `starship`
- **Media**: `mpv`, `yt-dlp`, `playerctl`
- **AI Tools**: `ollama`, `node.js` (for Gemini CLI)
- **Development**: `neovim`, `git`, `curl`, `jq`
- **Flatpak**: For SpeechNote integration

### Optional Dependencies

- **Claude Code**: AI-powered coding assistant
- **Spotify Premium**: For enhanced music integration
- **Zed Editor**: Alternative modern editor

---

## 🍫 Installation

### Automated Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ender4-dots.git
   cd ender4-dots
   ```

2. Run the installation script:
   ```bash
   bash install.sh
   ```

### Manual Installation (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ender4-dots.git
   cd ender4-dots
   ```

2. Install system dependencies:
   ```bash
   sudo pacman -Syu hyprland waybar dunst rofi-wayland ghostty fish neovim git
   ```

3. Install Krohnkite from AUR:
   ```bash
   yay -S kwin-scripts-krohnkite
   # or
   paru -S kwin-scripts-krohnkite
   ```

4. Copy configuration files:
   ```bash
   cp -r .config/* ~/.config/
   cp -r .local/* ~/.local/
   chmod +x ~/.local/bin/*
   ```

5. Install AI components (see [AI Integration](#ai-integration))

6. Restart your session or reload KWin:
   ```bash
   qdbus org.kde.KWin /KWin reconfigure
   ```

---

## 📼 Configuration

### Hyprland Setup

The configuration is modular and split across multiple files:

- `hyprland.conf`: Main configuration
- `custom/`: User-specific customizations
- `scripts/`: Automation and helper scripts

### QuickShell Interface

QuickShell provides a complete desktop experience:

- **Bar**: System information, workspaces, media controls
- **Sidebar**: AI chat, translator, music player
- **Widgets**: Calendar, weather, notifications
- **Overlays**: App launcher, session management

### Terminal Configuration

- **Ghostty**: Modern terminal with GPU acceleration
- **Fish Shell**: Intelligent completions and syntax highlighting
- **Starship**: Cross-shell prompt with git integration

---

## 🪟 KDE Window Management

### Krohnkite Tiling Manager

Ender4.Dots includes advanced window management through KWin and the Krohnkite tiling script:

#### Installation Prerequisites
```bash
# Install Krohnkite from AUR
yay -S kwin-scripts-krohnkite
```

#### Key Features
- **Automatic Tiling**: Intelligent window arrangement with multiple layout modes
- **Custom Exclusions**: Applications that shouldn't be tiled are automatically handled
- **Multi-Monitor Support**: Optimized for multiple display configurations
- **Dynamic Gaps**: Configurable window gaps and borders

#### Window Rules (`kwinrulesrc`)
The configuration includes comprehensive window rules for:

- **Development Tools**: IDEs, terminals, and code editors with optimal sizing
- **Media Applications**: Video players, image viewers with floating behavior
- **System Tools**: File managers, system settings with appropriate positioning
- **Gaming**: Games and emulators with fullscreen and performance optimizations
- **Communication**: Chat apps, email clients with sticky workspace assignments

#### KWin Configuration (`kwinrc`)
Includes optimized settings for:

- **Krohnkite Integration**: Tiling layouts and behavior
- **Animation Settings**: Smooth transitions and effects
- **Compositor Options**: Performance and visual quality balance
- **Window Decorations**: Minimalist borders and title bars
- **Focus Management**: Mouse and keyboard focus behavior

#### Keyboard Shortcuts
- **Meta + J/K/H/L**: Navigate between tiled windows
- **Meta + Shift + J/K/H/L**: Move windows in tiling layout
- **Meta + R**: Rotate window layout
- **Meta + Return**: Set window as master
- **Meta + T**: Toggle floating mode for current window

#### Customization
To modify window rules:
1. Use KDE System Settings → Window Management → Window Rules
2. Or edit `~/.config/kwinrulesrc` directly
3. Apply changes: `qdbus org.kde.KWin /KWin reconfigure`

---

## 🤖 AI Integration

Ender4.Dots includes comprehensive AI integration across multiple components. See [Docs/AI.md](Docs/AI.md) for detailed setup instructions including:

- **Voice Control**: Gemini CLI integration
- **Code Assistance**: Multiple AI providers in Neovim
- **Translation**: Real-time translation services
- **Music Control**: AI-powered Spotify integration

### Quick AI Setup

1. Install Ollama and configure local models
2. Set up API keys for external providers
3. Configure voice synthesis with SpeechNote
4. Follow Spotify integration guide in [Docs/SPOTIFY.md](Docs/SPOTIFY.md)

---

## 🌀 Usage

### Desktop Navigation

- **Super + Number**: Switch workspaces
- **Super + Shift + Number**: Move window to workspace
- **Super + Q**: Close window
- **Super + Return**: Open terminal
- **Super + D**: Application launcher

### Window Management (Krohnkite)

- **Meta + J/K/H/L**: Navigate tiled windows
- **Meta + Shift + J/K/H/L**: Move windows in layout
- **Meta + R**: Rotate layout
- **Meta + T**: Toggle floating mode

### AI Commands

- **Voice activation**: Say "start speaking now" to enable TTS
- **Music control**: "next song", "previous song", "pause music"
- **Code assistance**: Built into Neovim workflow
- **Translation**: Integrated in QuickShell sidebar

### Development Workflow

- **Neovim**: `nvim` for AI-enhanced code editing
- **Claude Code**: `claude-code` for AI pair programming
- **Debugging**: Integrated DAP configuration
- **Git integration**: Advanced git workflows

---

## ☕ Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## Acknowledgments

- [Hyprland](https://hyprland.org/) - Modern Wayland compositor
- [QuickShell](https://quickshell.org/) - QML desktop shell framework
- [Krohnkite](https://github.com/esjeon/krohnkite) - KWin tiling script
- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration framework
- [Ghostty](https://github.com/ghostty-org/ghostty) - Modern terminal emulator
- [Fish](https://fishshell.com/) - Smart command line shell
- AI Providers: Claude, OpenAI, Google Gemini, Ollama
- Arch Linux community and all open source contributors

---

<footer>
<sub>Crafted with Determination 👾 by Kuro • Powered by Arch Linux • Enhanced with AI • Managed with KDE</sub>
</footer>