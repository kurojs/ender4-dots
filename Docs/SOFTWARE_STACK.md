# EnderDots Software Stack

This document outlines the comprehensive stack of applications, CLI tools, and development utilities that power the EnderDots ecosystem. This is not a list of random packages; these are the actual tools deeply integrated into daily workflows, cognitive tasks, and language study.

## 🖥️ Desktop, Window Management & Input
- **KDE Plasma & KWin** *(Pacman)*: The core desktop environment and window manager, deeply configured with custom rules for an optimized, keyboard-centric workflow.
- **QuickShell** *(AUR / Source)*: Custom QML-based desktop shell providing overlays, widgets, and custom UI components beyond standard KDE panels.
- **Vicinae** *(GitHub / AUR)*: Blazing-fast, Raycast-style application launcher and productivity overlay.
- **Fcitx5 & Mozc** *(Pacman)*: The backbone for Japanese input (IME), critical for seamless switching between English/Spanish and Japanese typing.

## ⌨️ Terminals & Shells
- **Ghostty** *(AUR)*: Primary, GPU-accelerated terminal emulator written in Zig. Blazing fast with top-tier font rendering.
- **Warp** *(AUR / Web)*: Next-generation terminal used for built-in AI capabilities and IDE-like text editing features.
- **Tilda** *(Pacman)*: Drop-down terminal configured for quick, transient CLI tasks.
- **Fish Shell** *(Pacman)*: Default interactive shell, featuring out-of-the-box syntax highlighting and intelligent autosuggestions.
- **Starship** *(Pacman)*: Universal, cross-shell prompt keeping the CLI environment consistent.
- **Zoxide** *(Cargo)*: Smarter `cd` that learns your directory patterns. Navigate with `z <fragment>` and jump instantly.
- **Atuin** *(Cargo)*: SQLite-backed shell history with end-to-end encrypted sync, fuzzy search via Ctrl+R, and usage statistics.
- **Bat** *(Cargo)*: Modern `cat` replacement with syntax highlighting, line numbers, and Git integration.

## 🛠️ Editors, IDEs & Note-taking
- **OpenCode** *(Web / Installer)*: Deeply customized AI-native code editor. Optimized for fast iterations, autonomous agents, and contextual codebase understanding.
- **Neovim** *(Pacman)*: Keyboard-driven, high-performance editor configured via a custom LazyVim setup with integrated AI assistants (Avante) and LSP.
- **Zed** *(AUR / Pacman)*: High-performance, Rust-based multiplayer editor used for handling massive files and quick fluid edits.
- **JetBrains Toolbox (IDEA & Android Studio)** *(AUR)*: Heavy-duty IDEs for JVM, Kotlin, and Android development.
- **Obsidian & Notion** *(AUR / Web)*: Core knowledge bases. Obsidian for local, linked markdown vaults, and Notion for structured workspace tracking.

## 🤖 AI, Automation & Toolchains
- **Claude Code (`claude`)** *(NPM)*: Anthropic's official CLI tool for AI pair programming directly in the terminal.
- **GitHub Copilot CLI (`copilot`)** *(Local)*: GitHub's AI CLI assistant for quick command explanations, generation, and git operations.
- **Antigravity CLI (`agy`)** *(Local)*: Google's agentic AI command-line interface for AI integrations and voice control workflows.
- **OpenClaw (`openclaw`)** *(NPM)*: Specialized AI CLI agent tool installed globally for advanced automation and codebase tasks.
- **Pi / Gentle-Engram (`pi`, `pi-engram`)** *(NPM)*: Custom AI coding agents and persistent memory (Engram) adapters to retain context across sessions.
- **NotebookLM MCP CLI** *(Source)*: Integration for Google's NotebookLM, allowing interaction and research automation directly from the terminal.
- **ElevenLabs MCP TTS** *(Source)*: Local Model Context Protocol server enabling AI text-to-speech for high-quality voice interactions.
- **SpeechNote** *(Flatpak)*: Offline Speech-to-Text (STT) and Text-to-Speech (TTS) capabilities for privacy-focused local voice control.
- **UV & PNPM** *(Pacman / NPM)*: Blazing-fast package managers for Python (UV) and Node.js (PNPM) ecosystems.

## 🇯🇵 Language Study & Translation
- **ttu-ebook-reader** *(Web / GitHub)*: Highly customizable browser-based e-book reader, specifically optimized for vertical/horizontal Japanese text and lookup dictionaries.
- **Anki** *(Pacman / Flatpak)*: Spaced repetition flashcard system, essential for JLPT N1 vocabulary and kanji retention.
- **n1-translator & n1-tools** *(Custom / Source)*: Bespoke local translation tools and utilities built to aid advanced Japanese comprehension.
- **Custom OCR & TTS Scripts (`ocr-jp.sh`, `ocr-jp-tts.sh`, `ocr-jp-manga.sh`, `ocr-jp-tts-manga.sh`)** *(Local)*: Bash utilities leveraging Tesseract or [manga-ocr](https://github.com/kha-white/manga-ocr) and local/cloud TTS to extract Japanese text from screen selections and read them aloud natively.

## 🌐 Web Browsers
- **Zen Browser** *(AUR)*: Primary daily driver. A highly optimized, privacy-focused Firefox fork tailored for keyboard-driven workflows.
- **Vivaldi** *(Pacman)*: Secondary power-user browser for deep workspace management and tiling tabs.
- **FreeTube** *(Flatpak)*: Privacy-respecting, open-source YouTube client without tracking or ads.

## 🎵 Media, Entertainment & Comms
- **Spotify + Spicetify** *(AUR)*: Music streaming injected with Spicetify to strip telemetry, block ads, and apply the custom Kanagawa/Purple-Green aesthetic.
- **MPV** *(Pacman)*: The undisputed king of video players. Minimalist, scriptable, and highly efficient.
- **OBS Studio** *(Flatpak / Pacman)*: Standard for screen recording and streaming.
- **Cava & Cavalier** *(Pacman / Flatpak)*: Audio visualizers for aesthetic terminal and desktop background integration.
- **IPTVnator** *(AUR / AppImage)*: Electron-based IPTV player for streaming live media.
- **Discord & ZapZap** *(Flatpak / AUR)*: Primary communication hubs. ZapZap acts as the native WhatsApp client.

## ⚙️ Hardware, Emulation & Core CLI
- **Lazygit** *(Pacman)*: Essential terminal UI for Git. Makes staging, committing, and resolving merge conflicts incredibly fast.
- **GitHub CLI (`gh`)** *(Pacman)*: Command-line tool for creating PRs, managing issues, and reviewing code directly from the terminal.
- **Genymotion** *(AUR / Installer)*: High-performance Android emulation for testing and reverse engineering apps.
- **OpenRazer & Polychromatic** *(AUR)*: Drivers and GUI for managing Razer peripheral RGB lighting to match the desktop aesthetic.
- **Git, Curl, JQ, FZF, Ripgrep, FD** *(Pacman)*: The holy grail of UNIX terminal utilities required for fast navigation, search, and script parsing.
