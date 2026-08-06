-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                          GENTLEMAN DOTS - WEZTERM                            ║
-- ║                           Optimized for Neovim                               ║
-- ║                    Theme + keybinds portados de EnderDots                    ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local wezterm = require("wezterm")
local config = {}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                   FONT                                       │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.font_size = 18.0
-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  WINDOW                                      │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.window_background_opacity = 0.80
config.macos_window_background_blur = 20
config.win32_system_backdrop = "Acrylic"

config.window_padding = {
	top = 0,
	right = 0,
	left = 0,
	bottom = 0,
}

config.enable_scroll_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- No titlebar when launched by WTQ (quake mode)
if os.getenv("WTQ") == "1" then
  config.window_decorations = "RESIZE"
end

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  CURSOR                                      │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            NEOVIM OPTIMIZATIONS                              │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- Terminal & Colors
-- WSL doesn't have wezterm terminfo, so we use xterm-256color there
-- See: https://github.com/Gentleman-Programming/Gentleman.Dots/issues/117
if wezterm.target_triple:find("windows") then
  config.term = "xterm-256color"
else
  config.term = "wezterm"
end
config.enable_csi_u_key_encoding = true

-- Undercurl support (LSP diagnostics, spelling)
config.underline_thickness = 2
config.underline_position = -2

-- Scrollback
config.scrollback_lines = 10000

-- Performance
config.max_fps = 240

-- Image support
config.enable_kitty_graphics = true

-- Input handling
config.use_dead_keys = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                        GHOSTTY (EnderDots) THEME                            │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.colors = {
	-- Base Colors
	foreground = "#f3f6f9",
	background = "#000000",

	-- Cursor
	cursor_bg = "#7465a1",
	cursor_fg = "#f3f6f9",
	cursor_border = "#7465a1",

	-- Selection
	selection_fg = "#f3f6f9",
	selection_bg = "#7465a1",

	-- Normal Colors
	ansi = {
		"#06080f", -- black
		"#fca5a5", -- red
		"#86efac", -- green
		"#fcd34d", -- yellow
		"#7fb4ca", -- blue
		"#c4b5fd", -- magenta
		"#5c6170", -- cyan
		"#f3f6f9", -- white
	},

	-- Bright Colors
	brights = {
		"#1e293b", -- black
		"#eb6f92", -- red
		"#a6e3a1", -- green
		"#fde68a", -- yellow
		"#a3d4d5", -- blue
		"#e8a0bf", -- magenta
		"#94a3b8", -- cyan
		"#ffffff", -- white
	},
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                     GHOSTTY (EnderDots) KEYBINDINGS                          │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.keys = {
	-- Toggle pane zoom (ghostty: alt+f=toggle_split_zoom)
	{ key = "f", mods = "ALT", action = wezterm.action.TogglePaneZoomState },

	-- New splits (ghostty: alt+v=new_split:right, alt+d=new_split:down)
	{
		key = "v",
		mods = "ALT",
		action = wezterm.action.SplitPane {
			direction = "Right",
		},
	},
	{
		key = "d",
		mods = "ALT",
		action = wezterm.action.SplitPane {
			direction = "Down",
		},
	},

	-- Resize splits (ghostty: ctrl+shift+h/j/k/l=resize_split:*,10)
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Down", 10 } },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Up", 10 } },
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Left", 10 } },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize { "Right", 10 } },

	-- Move between splits (ghostty: alt+h/j/k/l=goto_split:*)
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Up" },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Down" },
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Left" },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Right" },

	-- Clear screen (ghostty: ctrl+k=clear_screen). WezTerm no tiene clear nativo:
	-- manda Ctrl+L (0x0c) al shell.
	{ key = "k", mods = "CTRL", action = wezterm.action.SendString "\x0c" },

	-- Insert newline (ghostty: shift+enter=text:\x1b\r)
	{ key = "Enter", mods = "SHIFT", action = wezterm.action.SendString "\x1b\r" },
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            WINDOWS (WSL)                                     │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- config.default_domain = 'WSL:Ubuntu-24.04'
config.default_domain = 'local'
config.front_end = "OpenGL"

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                           DEFAULT SHELL (Nushell)                            │
-- └──────────────────────────────────────────────────────────────────────────────┘

if wezterm.target_triple:find("windows") then
  config.default_prog = { "nu" }
end

return config
