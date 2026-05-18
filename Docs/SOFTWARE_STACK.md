# EnderDots Software Stack

This document outlines the core applications, CLI tools, and development utilities that power the EnderDots ecosystem. Everything here is actively used to drive productivity, AI integration, and language study workflows.

## 🖥️ Desktop & Window Management
- **KDE Plasma & KWin** *(Pacman)*: The core desktop environment and window manager, deeply configured with custom rules for an optimized, keyboard-centric workflow.
- **QuickShell** *(AUR / Source)*: A custom QML-based desktop shell that provides the overlays, widgets, and custom UI components beyond standard KDE panels.
- **Vicinae** *(GitHub / AUR)*: A blazing-fast, Raycast-style application launcher and productivity overlay.

## ⌨️ Terminals & Shells
- **Ghostty** *(AUR)*: The primary, GPU-accelerated terminal emulator written in Zig. Blazing fast with top-tier font rendering.
- **Warp** *(AUR / Web)*: Next-generation terminal used for its built-in AI capabilities and IDE-like text editing features.
- **Tilda** *(Pacman)*: Drop-down terminal configured for quick, transient CLI tasks.
- **Fish Shell** *(Pacman)*: The default interactive shell, featuring out-of-the-box syntax highlighting and intelligent autosuggestions.
- **Starship** *(Pacman)*: Universal, cross-shell prompt that keeps the CLI environment consistent and informative.

## 🛠️ Editors & IDEs
- **Neovim** *(Pacman)*: Keyboard-driven, high-performance editor. Configured via a custom LazyVim setup with integrated AI assistants (CodeCompanion/Avante) and LSP.
- **OpenCode** *(Web / Installer)*: Deeply customized AI-native code editor. Optimized for fast iterations, autonomous agents, and contextual codebase understanding.
- **Zed** *(AUR / Pacman)*: High-performance, Rust-based multiplayer editor used for handling massive files and quick, fluid edits.

## 🤖 AI & Automation CLI
- **Claude Code (`claude`)** *(NPM)*: Anthropic's official CLI tool for AI pair programming directly in the terminal.
- **NotebookLM MCP CLI** *(Source / Custom)*: Integration for Google's NotebookLM, allowing interaction and research automation directly from the terminal and editors.
- **ElevenLabs MCP TTS** *(Source / Custom)*: Local Model Context Protocol server that enables AI text-to-speech for seamless voice interactions.
- **Wayland MCP** *(Source / Custom)*: Custom automation scripts bridging Wayland/KDE compositor commands with AI agents.

## 🇯🇵 Language Study & Reading
- **ttu-ebook-reader** *(Web / GitHub)*: Highly customizable browser-based e-book reader, specifically optimized for vertical/horizontal Japanese text and lookup dictionaries.
- **Custom OCR & TTS Scripts (`ocr-jp.sh`, `ocr-jp-tts.sh`)** *(Local)*: Bash utilities leveraging Tesseract and local/cloud TTS to extract Japanese text from screen selections and read them aloud natively.

## 🎵 Media & Entertainment
- **Spotify + Spicetify** *(AUR)*: Music streaming injected with Spicetify to strip telemetry, block ads, and apply the custom EnderDots (Kanagawa/Purple-Green) aesthetic.
- **MPV** *(Pacman)*: The undisputed king of video players. Minimalist, scriptable, and highly efficient.
- **IPTVnator** *(AUR / AppImage)*: Electron-based IPTV player for streaming live media.

## ⚙️ Core Utilities
- **Git, Curl, JQ, FZF, Ripgrep, FD** *(Pacman)*: The holy grail of UNIX terminal utilities required for fast navigation, search, and script parsing.
