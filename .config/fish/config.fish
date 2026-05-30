if status is-interactive
    set fish_greeting
    starship init fish | source

    # Kurox syntax colors
    set fish_color_command 86efac
    set fish_color_param c4b5fd
    set fish_color_error eb6f92
    set fish_color_autosuggestion 5c6170
    set fish_color_comment 5c6170
    set fish_color_operator f6c177
    set fish_color_escape e8a0bf
    set fish_color_redirection f6c177
    set fish_color_valid_path --underline
end

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias q 'qs -c ii'
alias setwallpaper '$HOME/.config/hypr/scripts/wallpaper.sh set'

# opencode
fish_add_path /home/kuro/.opencode/bin

# Local binaries
fish_add_path /home/kuro/.local/bin

fish_add_path /home/kuro/.spicetify
fish_add_path $HOME/.npm-global/bin

# OpenClaw Completion
test -f "/home/kuro/.openclaw/completions/openclaw.fish"; and source "/home/kuro/.openclaw/completions/openclaw.fish"


# Added by Antigravity CLI installer
set -gx PATH "/home/kuro/.local/bin" $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
