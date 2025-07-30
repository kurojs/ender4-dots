function fish_prompt -d "Custom prompt with emoji and path"
    set -l last_status $status
    set -l cmd_duration $CMD_DURATION
    
    # Colors
    set -l purple '#ce08ff'
    set -l dark_purple '#5d00ff' 
    set -l matrix_green '#00ff41'
    set -l gray '#666666'
    set -l white '#ffffff'
    
    # Path
    set -l cwd (prompt_pwd)
    
    # Time
    set -l time_str (date "+%H:%M")
    
    # Duration (if command took more than 2 seconds)
    set -l duration_str ""
    if test $cmd_duration -gt 2000
        set duration_str (printf "took %ds" (math $cmd_duration / 1000))
    end
    
    # Tech stack detection
    set -l tech_icons ""
    
    # JavaScript/Node.js
    if test -f package.json
        set tech_icons "$tech_icons⚡"
    end
    
    # Python
    if test -f requirements.txt; or test -f pyproject.toml; or test -f setup.py; or test -f Pipfile
        set tech_icons "$tech_icons🐍"
    end
    
    # Rust
    if test -f Cargo.toml
        set tech_icons "$tech_icons🦀"
    end
    
    # Go
    if test -f go.mod; or test -f go.sum
        set tech_icons "$tech_icons🐹"
    end
    
    # PHP
    if test -f composer.json; or test -f composer.lock
        set tech_icons "$tech_icons🐘"
    end
    
    # Java
    if test -f pom.xml; or test -f build.gradle; or test -f build.gradle.kts
        set tech_icons "$tech_icons☕"
    end
    
    # C/C++
    if test -f CMakeLists.txt; or test -f Makefile; or test -f makefile
        set tech_icons "$tech_icons⚙️"
    end
    
    # Ruby
    if test -f Gemfile; or test -f Rakefile
        set tech_icons "$tech_icons💎"
    end
    
    # Docker
    if test -f Dockerfile; or test -f docker-compose.yml; or test -f docker-compose.yaml
        set tech_icons "$tech_icons🐳"
    end
    
    # Check for file extensions in current directory
    set -l files (ls 2>/dev/null)
    for file in $files
        switch $file
            case "*.js" "*.mjs"
                if not string match -q "*⚡*" "$tech_icons"
                    set tech_icons "$tech_icons⚡"
                end
            case "*.jsx" "*.tsx"
                set tech_icons "$tech_icons⚛️"
            case "*.py"
                if not string match -q "*🐍*" "$tech_icons"
                    set tech_icons "$tech_icons🐍"
                end
            case "*.rs"
                if not string match -q "*🦀*" "$tech_icons"
                    set tech_icons "$tech_icons🦀"
                end
            case "*.go"
                if not string match -q "*🐹*" "$tech_icons"
                    set tech_icons "$tech_icons🐹"
                end
            case "*.php"
                if not string match -q "*🐘*" "$tech_icons"
                    set tech_icons "$tech_icons🐘"
                end
            case "*.java"
                if not string match -q "*☕*" "$tech_icons"
                    set tech_icons "$tech_icons☕"
                end
            case "*.c" "*.cpp" "*.h" "*.hpp"
                if not string match -q "*⚙️*" "$tech_icons"
                    set tech_icons "$tech_icons⚙️"
                end
            case "*.rb"
                if not string match -q "*💎*" "$tech_icons"
                    set tech_icons "$tech_icons💎"
                end
            case "*.cs"
                set tech_icons "$tech_icons🔷"
            case "*.vue"
                set tech_icons "$tech_icons🟢"
            case "*.tf" "*.tfvars"
                set tech_icons "$tech_icons🌍"
        end
    end
    
    # First line: path, duration, tech icons + time
    printf '%s%s%s' (set_color $matrix_green) $cwd (set_color normal)
    
    set -l right_info ""
    if test -n "$duration_str"
        set right_info "$duration_str    "
    end
    
    # Add tech icons before time
    if test -n "$tech_icons"
        set right_info "$right_info$tech_icons "
    end
    
    set right_info "$right_info$time_str"
    
    # Get terminal width safely
    set -l term_cols (tput cols 2>/dev/null; or echo 80)
    set -l cwd_len (string length $cwd)
    set -l info_len (string length $right_info)
    
    # Calculate spaces needed with safe integer conversion
    set -l total_used (math $cwd_len + $info_len + 4)
    set -l spaces_needed (math $term_cols - $total_used)
    
    if test $spaces_needed -gt 0
        printf '%s' (string repeat -n $spaces_needed ' ')
    end
    
    printf '%s%s%s\n' (set_color $gray) $right_info (set_color normal)
    
    # Second line: emoji and arrow
    printf '%s👾 ➜ %s' (set_color $purple) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

# starship init fish | source # Disabled for custom prompt
# Quickshell terminal colors disabled - using custom colors instead
# if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
#     cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
# end

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias q 'qs -c ii'
alias setwallpaper '$HOME/.config/hypr/scripts/wallpaper.sh set'
    

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end

# opencode
fish_add_path /home/kuro/.opencode/bin

# Local binaries
fish_add_path /home/kuro/.local/bin
