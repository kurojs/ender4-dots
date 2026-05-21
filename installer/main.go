package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/key"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	purple   = lipgloss.Color("#a855f7")
	green    = lipgloss.Color("#22c55e")
	red      = lipgloss.Color("#ef4444")
	gray     = lipgloss.Color("#6b7280")
	faint    = lipgloss.Color("#444444")
	bg       = lipgloss.Color("#1a1a2e")

	titleStyle   = lipgloss.NewStyle().Bold(true).Foreground(purple).Padding(0, 1)
	itemStyle    = lipgloss.NewStyle().PaddingLeft(2)
	selectedStyle = lipgloss.NewStyle().Foreground(green).PaddingLeft(2)
	installedStyle = lipgloss.NewStyle().Foreground(gray).PaddingLeft(2)
	statusStyle  = lipgloss.NewStyle().Foreground(gray).PaddingLeft(2)
	errorStyle   = lipgloss.NewStyle().Foreground(red).PaddingLeft(2)
	keyStyle     = lipgloss.NewStyle().Foreground(purple)
	descStyle    = lipgloss.NewStyle().Foreground(gray).PaddingLeft(4)
	helpStyle    = lipgloss.NewStyle().Foreground(faint).PaddingLeft(2)
	doneStyle    = lipgloss.NewStyle().Foreground(green).Bold(true)
)

type component struct {
	name        string
	description string
	source      string
	target      string
	dir         bool
}

var components = []component{
	{name: "Neovim", description: "Complete LazyVim-based setup with AI plugins and LSP", source: ".config/nvim", target: ".config/nvim", dir: true},
	{name: "Fish Shell", description: "Aliases, functions, and prompt configuration", source: ".config/fish", target: ".config/fish", dir: true},
	{name: "OpenCode", description: "AI-first IDE configuration with keybindings", source: ".config/opencode", target: ".config/opencode", dir: true},
	{name: "Zed", description: "Zed editor settings and keybindings", source: ".config/zed", target: ".config/zed", dir: true},
	{name: "Ghostty", description: "Ghostty terminal emulator configuration", source: ".config/ghostty", target: ".config/ghostty", dir: true},
	{name: "Starship Prompt", description: "Cross-shell prompt with green/purple theme", source: ".config/starship.toml", target: ".config/starship.toml", dir: false},
	{name: "KDE Window Rules", description: "Tiling shortcuts and window management rules", source: ".config/kwinrc", target: ".config/kwinrc", dir: false},
	{name: "KDE Shortcuts", description: "Custom keyboard shortcut scheme (kuromy)", source: ".config/kuromy.kksrc", target: ".config/kuromy.kksrc", dir: false},
	{name: "QuickShell", description: "Custom desktop widget interface", source: ".config/quickshell", target: ".config/quickshell", dir: true},
	{name: "Tilda", description: "Drop-down terminal settings", source: ".config/tilda", target: ".config/tilda", dir: true},
	{name: "Custom Scripts", description: "OCR, Spotify, TTS, and utility scripts (~/.local/bin)", source: ".local/bin", target: ".local/bin", dir: true},
	{name: "Vicinae Themes", description: "Gentleman Kanagawa Blur theme for Vicinae", source: "usr/share/vicinae/themes", target: ".local/share/vicinae/themes", dir: true},
	{name: "Gemini Config", description: "Gemini CLI authentication and configuration", source: ".gemini", target: ".gemini", dir: true},
	{name: "Documents", description: "Project docs and reference files", source: "home/user/Documents", target: "Documents", dir: true},
}

type model struct {
	choices     []bool
	cursor      int
	installing  bool
	done        bool
	results     []string
	installAll  bool
	showHelp    bool
	help        help.Model
	keys        keyMap
	width       int
	height      int
}

type keyMap struct {
	Up       key.Binding
	Down     key.Binding
	Toggle   key.Binding
	SelectAll key.Binding
	Install  key.Binding
	Quit     key.Binding
	Help     key.Binding
}

func (k keyMap) ShortHelp() []key.Binding {
	return []key.Binding{k.Help, k.Quit}
}

func (k keyMap) FullHelp() [][]key.Binding {
	return [][]key.Binding{
		{k.Up, k.Down, k.Toggle},
		{k.SelectAll, k.Install},
		{k.Help, k.Quit},
	}
}

func initialModel() model {
	choices := make([]bool, len(components))
	for i := range choices {
		choices[i] = true
	}
	return model{
		choices: choices,
		cursor:  0,
		help:    help.New(),
		keys: keyMap{
			Up:        key.NewBinding(key.WithKeys("up", "k"), key.WithHelp("↑/k", "up")),
			Down:      key.NewBinding(key.WithKeys("down", "j"), key.WithHelp("↓/j", "down")),
			Toggle:    key.NewBinding(key.WithKeys(" ", "enter"), key.WithHelp("space", "toggle")),
			SelectAll: key.NewBinding(key.WithKeys("a"), key.WithHelp("a", "select/deselect all")),
			Install:   key.NewBinding(key.WithKeys("i"), key.WithHelp("i", "install selected")),
			Quit:      key.NewBinding(key.WithKeys("q", "esc", "ctrl+c"), key.WithHelp("q/esc", "quit")),
			Help:      key.NewBinding(key.WithKeys("?"), key.WithHelp("?", "help")),
		},
	}
}

func (m model) Init() tea.Cmd { return nil }

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	if m.installing || m.done {
		switch msg := msg.(type) {
		case tea.KeyMsg:
			switch msg.String() {
			case "q", "esc", "ctrl+c":
				return m, tea.Quit
			}
		case installResult:
			m.installing = false
			m.done = true
			m.results = msg.results
			return m, nil
		}
		return m, nil
	}

	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		m.help.Width = msg.Width
		return m, nil
	case tea.KeyMsg:
		switch {
		case key.Matches(msg, m.keys.Quit):
			return m, tea.Quit
		case key.Matches(msg, m.keys.Help):
			m.showHelp = !m.showHelp
			return m, nil
		case key.Matches(msg, m.keys.Up):
			if m.cursor > 0 {
				m.cursor--
			}
		case key.Matches(msg, m.keys.Down):
			if m.cursor < len(components)-1 {
				m.cursor++
			}
		case key.Matches(msg, m.keys.Toggle):
			m.choices[m.cursor] = !m.choices[m.cursor]
		case key.Matches(msg, m.keys.SelectAll):
			m.installAll = !m.installAll
			for i := range m.choices {
				m.choices[i] = m.installAll
			}
		case key.Matches(msg, m.keys.Install):
			m.installing = true
			return m, installCmd(m.choices)
		}
	}

	return m, nil
}

type installResult struct {
	results []string
}

func installCmd(choices []bool) tea.Cmd {
	return func() tea.Msg {
		var results []string
		srcBase := "/usr/share/ender-dots"
		if _, err := os.Stat(srcBase); os.IsNotExist(err) {
			srcBase = filepath.Join(findRepoRoot(), "..")
		}
		home, _ := os.UserHomeDir()

		for i, comp := range components {
			if !choices[i] {
				continue
			}
			src := filepath.Join(srcBase, comp.source)
			tgt := filepath.Join(home, comp.target)

			if _, err := os.Stat(src); os.IsNotExist(err) {
				results = append(results, fmt.Sprintf("  ✗ %s — source not found: %s", comp.name, src))
				continue
			}

			if comp.dir {
				parent := filepath.Dir(tgt)
				if err := os.MkdirAll(parent, 0755); err != nil {
					results = append(results, fmt.Sprintf("  ✗ %s — %v", comp.name, err))
					continue
				}
				if _, err := os.Lstat(tgt); err == nil {
					os.RemoveAll(tgt)
				}
				if err := os.Symlink(src, tgt); err != nil {
					results = append(results, fmt.Sprintf("  ✗ %s — %v", comp.name, err))
					continue
				}
			} else {
				parent := filepath.Dir(tgt)
				if err := os.MkdirAll(parent, 0755); err != nil {
					results = append(results, fmt.Sprintf("  ✗ %s — %v", comp.name, err))
					continue
				}
				if err := os.Symlink(src, tgt); err != nil {
					if os.IsExist(err) {
						os.Remove(tgt)
						if err := os.Symlink(src, tgt); err != nil {
							results = append(results, fmt.Sprintf("  ✗ %s — %v", comp.name, err))
							continue
						}
					} else {
						results = append(results, fmt.Sprintf("  ✗ %s — %v", comp.name, err))
						continue
					}
				}
			}
			results = append(results, fmt.Sprintf("  ✓ %s", comp.name))
		}

		return installResult{results: results}
	}
}

func findRepoRoot() string {
	cmd := exec.Command("git", "rev-parse", "--show-toplevel")
	out, err := cmd.Output()
	if err != nil {
		return "."
	}
	return strings.TrimSpace(string(out))
}

func (m model) View() string {
	var b strings.Builder

	b.WriteString(titleStyle.Render("EnderDots Installer"))
	b.WriteString("\n\n")

	if m.installing {
		b.WriteString(statusStyle.Render("Installing selected components...\n"))

		frame := []string{"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
		spinner := frame[0]
		b.WriteString(fmt.Sprintf("\n  %s  Working...\n", spinner))
		return b.String()
	}

	if m.done {
		b.WriteString(doneStyle.Render("Installation complete!\n\n"))
		for _, r := range m.results {
			b.WriteString(r + "\n")
		}
		b.WriteString("\n")
		b.WriteString(helpStyle.Render("Press q or esc to quit"))
		return b.String()
	}

	b.WriteString(fmt.Sprintf("Select components to install (%d/%d selected)\n\n", countSelected(m.choices), len(components)))

	if m.showHelp {
		b.WriteString(helpStyle.Render(m.help.View(m.keys)))
		return b.String()
	}

	maxLen := 0
	for _, c := range components {
		if len(c.name) > maxLen {
			maxLen = len(c.name)
		}
	}

	for i, comp := range components {
		checkbox := "  "
		if m.choices[i] {
			checkbox = "🟢"
		}

		cursor := "  "
		if m.cursor == i {
			cursor = "▸"
		}

		name := comp.name
		padding := strings.Repeat(" ", maxLen-len(name))

		if m.cursor == i {
			b.WriteString(selectedStyle.Render(fmt.Sprintf("%s %s %s%s", cursor, checkbox, name, padding)))
		} else if m.choices[i] {
			b.WriteString(selectedStyle.Render(fmt.Sprintf("%s %s %s%s", cursor, checkbox, name, padding)))
		} else {
			b.WriteString(itemStyle.Render(fmt.Sprintf("%s %s %s%s", cursor, checkbox, name, padding)))
		}
		b.WriteString("\n")

		if m.cursor == i {
			b.WriteString(descStyle.Render(comp.description))
			b.WriteString("\n")
		}
	}

	b.WriteString("\n")
	b.WriteString(helpStyle.Render("  ↑/k ↓/j navigate • space toggle • a select/deselect all • i install • ? help • q/esc quit"))

	return b.String()
}

func countSelected(choices []bool) int {
	count := 0
	for _, c := range choices {
		if c {
			count++
		}
	}
	return count
}

func main() {
	p := tea.NewProgram(initialModel(), tea.WithAltScreen())
	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
