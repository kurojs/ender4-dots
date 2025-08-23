# AI Integration - Ender4.Dots

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-6e40c9?logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Bash](https://img.shields.io/badge/Bash-6e40c9?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Python-6e40c9?logo=python&logoColor=white)](https://www.python.org/)
[![Node.js](https://img.shields.io/badge/Node.js-6e40c9?logo=node.js&logoColor=white)](https://nodejs.org/)
[![mpv](https://img.shields.io/badge/MPV-6e40c9?logo=mpv&logoColor=white)](https://mpv.io/)
[![yt-dlp](https://img.shields.io/badge/yt--dlp-6e40c9)](https://github.com/yt-dlp/yt-dlp)
[![playerctl](https://img.shields.io/badge/playerctl-6e40c9)](https://github.com/altdesktop/playerctl)
[![SpeechNote](https://img.shields.io/badge/SpeechNote-6e40c9)](https://github.com/mkiol/SpeechNote)
[![Ollama](https://img.shields.io/badge/Ollama-6e40c9)](https://ollama.ai/)
[![License: MIT](https://img.shields.io/badge/License-MIT-6e40c9)](https://opensource.org/licenses/MIT)

> AI Integration Guide for Ender4.Dots – The Complete Desktop Environment with AI

This document covers the AI integration components within Ender4.Dots, a comprehensive desktop environment for Arch Linux. The AI features include voice control, intelligent code assistance, real-time translation, and smart automation across the entire desktop experience.

---

## 📦 Table of Contents

1. [Overview](#overview)
2. [AI Components](#ai-components)
3. [Installation](#installation)
4. [Configuration](#configuration)
   - [Gemini CLI Setup](#gemini-cli-setup)
   - [Neovim AI Plugins](#neovim-ai-plugins)
   - [Voice Synthesis](#voice-synthesis)
   - [Spotify Integration](#spotify-integration)
5. [Available AI Commands](#available-ai-commands)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Configuration](#advanced-configuration)

---

## 👾 Overview

Ender4.Dots integrates AI capabilities throughout the entire desktop environment:

- **Voice-Controlled Desktop**: Seamless integration with Gemini CLI for system control
- **Intelligent Code Editing**: Multiple AI providers in Neovim (Claude, OpenAI, Copilot)
- **Smart Translation**: Real-time translation in QuickShell interface
- **Music Intelligence**: AI-powered Spotify control and recommendations
- **System Automation**: Intelligent scripts and workflow optimization

---

## 🧰 AI Components

### Development Environment
- **Avante.nvim**: Claude integration for code assistance
- **CodeCompanion.nvim**: Multi-provider AI chat and coding
- **GitHub Copilot**: Intelligent code completion
- **Claude Code**: Direct Claude integration for pair programming
- **Gemini**: Code analysis and suggestions

### Desktop Intelligence
- **Gemini CLI**: Voice commands and system control
- **QuickShell AI**: Integrated translation and chat widgets
- **Ollama Integration**: Local AI models for privacy
- **Speech Synthesis**: SpeechNote for voice feedback

### Multimedia AI
- **Smart Music Control**: AI-powered Spotify integration
- **Media Processing**: Intelligent yt-dlp and mpv controls
- **Voice Commands**: Natural language media control

---

## 🛠 Installation

### AI Dependencies

```bash
# Core AI tools
sudo pacman -S python nodejs npm ollama

# Media tools for AI integration
sudo pacman -S yt-dlp mpv playerctl

# Flatpak for SpeechNote
flatpak install -y flathub net.mkiol.SpeechNote
```

### AI Model Setup

1. **Ollama Models**:
   ```bash
   # Install local models
   ollama pull codellama
   ollama pull llama2
   ollama pull mistral
   ```

2. **Gemini CLI**:
   ```bash
   npm install -g @google/generative-ai
   # Configure API key (see configuration section)
   ```

3. **Claude Code**:
   ```bash
   # Follow installation instructions at https://docs.anthropic.com/claude-code
   ```

---

## 📼 Configuration

### Gemini CLI Setup

1. **Install and configure Gemini CLI**:
   ```bash
   mkdir -p ~/.gemini
   cp .gemini/GEMINI.md ~/.gemini/
   ```

2. **Set up API credentials**:
   ```bash
   export GEMINI_API_KEY="your_api_key_here"
   ```

3. **Configure voice commands** (see `.gemini/GEMINI.md` for full instructions):
   - `"start speaking now"` - Enable voice synthesis
   - `"next song"` - Skip to next track
   - `"play {song}"` - Play specific music
   - `"translate this"` - Activate translation

### Neovim AI Plugins

The configuration includes multiple AI providers configured in `~/.config/nvim/lua/plugins/`:

- **Avante** (`avante.lua`): Claude integration
- **CodeCompanion** (`code-companion.lua`): Multi-provider chat
- **Copilot** (`copilot.lua`): GitHub's AI assistant
- **Gemini** (`gemini.lua`): Google's AI integration

### Voice Synthesis Configuration

1. **SpeechNote setup**:
   ```bash
   # Wrapper script for voice synthesis
   ~/.local/bin/speech_wrapper.sh "Text to speak"
   ```

2. **Voice activation in Gemini CLI**:
   - Instruction: `"start speaking now"`
   - Command executed: `~/.local/bin/speech_wrapper.sh "{response}"`

### Spotify AI Integration

> ❗ **Important Warning**  
> Before proceeding, read `SPOTIFY.md` for detailed Spotify API setup instructions.  
> This integration requires your **Spotify Client ID** and **Client Secret**.

1. **Token management**:
   ```bash
   python3 ~/.local/bin/get_spotify_token.py
   ```

2. **AI music commands**:
   - `"play {song_name}"` - Search and play specific songs
   - `"my playlist"` - Play your saved playlists
   - `"next song"` / `"previous song"` - Playback control
   - `"pause music"` / `"resume music"` - Playback control

---

## 🤖 Available AI Commands

### Voice Control Commands

#### **General AI Interaction**
- `"start speaking now"` or `"speak out loud"`
  - Enables voice synthesis for AI responses
  - Command: `~/.local/bin/speech_wrapper.sh "{output_text}"`

#### **Music Control**
- `"next song"` → `playerctl next`
- `"previous song"` → `playerctl previous`  
- `"pause music"` / `"resume music"` → `playerctl play-pause`
- `"play {song}"` → `~/.local/bin/play "{song}"`

#### **System Control**
- `"translate this"` - Activate translation widget
- `"show AI models"` - Display loaded Ollama models
- `"workspace {number}"` - Switch workspaces via voice

### Development AI Commands

#### **Neovim Integration**
- `:AvChat` - Start Claude conversation
- `:CodeCompanionChat` - Multi-provider AI chat
- `:Copilot suggest` - Get code suggestions
- `:GeminiChat` - Google AI assistance

#### **Claude Code Integration**
```bash
# Direct Claude assistance
claude-code --help
claude-code analyze file.py
claude-code review --diff
```

---

## 🌀 Troubleshooting

### Common Issues

1. **Voice synthesis not working**:
   ```bash
   # Check SpeechNote installation
   flatpak list | grep SpeechNote
   
   # Test voice wrapper
   ~/.local/bin/speech_wrapper.sh "Test message"
   ```

2. **Spotify integration failing**:
   ```bash
   # Check token file exists
   ls ~/.local/bin/spotify_token.json
   
   # Regenerate token
   python3 ~/.local/bin/get_spotify_token.py
   ```

3. **AI models not loading**:
   ```bash
   # Check Ollama status
   ollama list
   ollama ps
   
   # Restart Ollama service
   systemctl restart ollama
   ```

4. **Gemini CLI not responding**:
   ```bash
   # Check API key configuration
   echo $GEMINI_API_KEY
   
   # Test basic functionality
   gemini-cli "Hello, test message"
   ```

---

## ☕ Advanced Configuration

### Custom AI Prompts

Add custom prompts to `.gemini/GEMINI.md`:

```markdown
## Custom Commands

- **Instruction**: `"your custom command"`
- **Action**: Execute custom script or command
```

### Local AI Models

Configure additional Ollama models:

```bash
# Install specialized models
ollama pull deepseek-coder
ollama pull phi
ollama pull neural-chat
```

### Multi-Provider Setup

Configure multiple AI providers in Neovim:

```lua
-- ~/.config/nvim/lua/config/ai-providers.lua
return {
  claude = { api_key = os.getenv("CLAUDE_API_KEY") },
  openai = { api_key = os.getenv("OPENAI_API_KEY") },
  gemini = { api_key = os.getenv("GEMINI_API_KEY") },
}
```

---

## Acknowledgments

- [Gemini CLI](https://github.com/google/gemini-cli) by Google
- [SpeechNote](https://github.com/mkiol/SpeechNote) by mkiol
- [Ollama](https://ollama.ai/) for local AI models
- [Avante.nvim](https://github.com/yetone/avante.nvim) for Claude integration
- [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim) for multi-provider support
- Tools: `yt-dlp`, `mpv`, `playerctl`
- Arch Linux community and AI/ML open source contributors

---

<footer>
<sub>Part of Ender4.Dots • Crafted with Determination 👾 by Kuro • Enhanced with AI</sub>
</footer>