# ============================================================
# Nushell config - estilo EnderDots (portado de fish + starship)
# ============================================================

# --- Colores Kurox (portados de config.fish) ---
$env.config.color_config = {
  separator: "#5c6170"
  leading_trailing_space_bg: { attr: "n" }
  header: "#86efac"
  empty: "#94a3b8"
  bool: "#c4b5fd"
  int: "#f6c177"
  filesize: "#94a3b8"
  duration: "#f6c177"
  date: "#e8a0bf"
  range: "#f6c177"
  float: "#f6c177"
  string: "#c4b5fd"
  nothing: "#eb6f92"
  binary: "#f6c177"
  cell-path: "#94a3b8"
  row_index: "#86efac"
  record: "#94a3b8"
  list: "#94a3b8"
  block: "#94a3b8"
  hints: "#5c6170"
  search_result: { bg: "#eb6f92" fg: "#ffffff" }
  shape_string: "#c4b5fd"
  shape_string_interpolation: "#f6c177"
  shape_datetime: "#e8a0bf"
  shape_list: "#86efac"
  shape_table: "#86efac"
  shape_record: "#f6c177"
  shape_block: "#8f86e8"
  shape_filepath: "#c4b5fd"
  shape_directory: "#8f86e8"
  shape_globpattern: "#f6c177"
  shape_variable: "#e8a0bf"
  shape_flag: "#8f86e8"
  shape_custom: "#f6c177"
  shape_bool: "#86efac"
  shape_int: "#f6c177"
  shape_float: "#f6c177"
  shape_range: "#f6c177"
  shape_operator: "#f6c177"
  shape_redirection: "#f6c177"
  shape_external: "#86efac"
  shape_externalarg: "#c4b5fd"
  shape_pipe: "#f6c177"
  shape_signature: "#86efac"
  shape_keyword: "#e8a0bf"
  shape_glob_interpolation: "#f6c177"
  shape_garbage: { fg: "#ffffff" bg: "#eb6f92" attr: "b" }
}

$env.config.shell_integration.osc133 = false
$env.config.show_banner = false

# --- Aliases git (portados de fish abbr) ---
alias gc = git commit
alias gca = git commit --amend
alias gp = git push
alias gpf = git push --force-with-lease
alias gl = git log --oneline --graph
alias gs = git status
alias gd = git diff
alias ga = git add
alias gco = git checkout
alias gb = git branch

# ============================================================
# Atuin (historial) - generado por `atuin init nu`
# ============================================================
# Source this in your ~/.config/nushell/config.nu
# minimum supported version = 0.93.0
module compat {
  export def --wrapped "random uuid -v 7" [...rest] { atuin uuid }
}
use (if not (
    (version).major > 0 or
    (version).minor >= 103
) { "compat" }) *

if 'ATUIN_SESSION' not-in $env or ('ATUIN_SHLVL' not-in $env) or ($env.ATUIN_SHLVL != ($env.SHLVL? | default "")) {
    $env.ATUIN_SESSION = (random uuid -v 7 | str replace -a "-" "")
    $env.ATUIN_SHLVL = ($env.SHLVL? | default "")
}
hide-env -i ATUIN_HISTORY_ID

def _atuin_osc133_command_executed [] {
    if 'ATUIN_PTY_PROXY_ACTIVE' not-in $env {
        return
    }
    if 'ATUIN_HISTORY_ID' not-in $env or ($env.ATUIN_HISTORY_ID | is-empty) {
        return
    }

    print -n $"(char -u '1b')]133;C(char bel)"
}

def _atuin_osc133_command_finished [exit_code: int] {
    if 'ATUIN_PTY_PROXY_ACTIVE' not-in $env {
        return
    }
    if 'ATUIN_HISTORY_ID' not-in $env or ($env.ATUIN_HISTORY_ID | is-empty) {
        return
    }

    print -n $"(char -u '1b')]133;D;($exit_code);history_id=($env.ATUIN_HISTORY_ID);session_id=($env.ATUIN_SESSION)(char bel)"
}

# Magic token to make sure we don't record commands run by keybindings
let ATUIN_KEYBINDING_TOKEN = $"# (random uuid)"

let _atuin_pre_execution = {||
    if ($nu | get history-enabled?) == false {
        return
    }
    let cmd = (commandline)
    if ($cmd | is-empty) {
        return
    }
    if not ($cmd | str starts-with $ATUIN_KEYBINDING_TOKEN) {
        $env.ATUIN_HISTORY_ID = (with-env { ATUIN_SHELL: nu } {
            atuin history start --hook -- $cmd | complete | get stdout | str trim
        })
        _atuin_osc133_command_executed
    }
}

let _atuin_pre_prompt = {||
    let last_exit = $env.LAST_EXIT_CODE
    if 'ATUIN_HISTORY_ID' not-in $env {
        return
    }
    _atuin_osc133_command_finished $last_exit
    if (version).minor >= 104 or (version).major > 0 {
        job spawn {
            ^atuin history end --hook $'--exit=($env.LAST_EXIT_CODE)' -- $env.ATUIN_HISTORY_ID | complete
        } | ignore
    } else {
        do { atuin history end --hook $'--exit=($last_exit)' -- $env.ATUIN_HISTORY_ID } | complete
    }
    hide-env -i ATUIN_HISTORY_ID
}

def _atuin_search_cmd [...flags: string] {
    if (version).minor >= 106 or (version).major > 0 {
        [
            $ATUIN_KEYBINDING_TOKEN,
            ([
                `with-env { ATUIN_QUERY: (commandline), ATUIN_SHELL: nu } {`,
                    ([
                        'let output = (run-external atuin search',
                        ($flags | append [--interactive] | each {|e| $'"($e)"'}),
                        'e>| str trim)',
                    ] | flatten | str join ' '),
                    'if ($output | str starts-with "__atuin_accept__:") {',
                    'commandline edit --accept ($output | str replace "__atuin_accept__:" "")',
                    '} else {',
                    'commandline edit $output',
                    '}',
                `}`,
            ] | flatten | str join "\n"),
        ]
    } else {
        [
            $ATUIN_KEYBINDING_TOKEN,
            ([
                `with-env { ATUIN_QUERY: (commandline) } {`,
                    'commandline edit',
                    '(run-external atuin search',
                        ($flags | append [--interactive] | each {|e| $'"($e)"'}),
                    ' e>| str trim)',
                `}`,
            ] | flatten | str join ' '),
        ]
    } | str join "\n"
}

$env.config = ($env | default {} config).config
$env.config = ($env.config | default {} hooks)
$env.config = (
    $env.config | upsert hooks (
        $env.config.hooks
        | upsert pre_execution (
            $env.config.hooks | get pre_execution? | default [] | append $_atuin_pre_execution)
        | upsert pre_prompt (
            $env.config.hooks | get pre_prompt? | default [] | append $_atuin_pre_prompt)
    )
)

$env.config = ($env.config | default [] keybindings)
$env.config = (
    $env.config | upsert keybindings (
        $env.config.keybindings
        | append {
            name: atuin
            modifier: control
            keycode: char_r
            mode: [emacs, vi_normal, vi_insert]
            event: { send: executehostcommand cmd: (_atuin_search_cmd) }
        }
    )
)
$env.config = (
    $env.config | upsert keybindings (
        $env.config.keybindings
        | append {
            name: atuin
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuup}
                    {send: executehostcommand cmd: (_atuin_search_cmd '--shell-up-key-binding') }
                ]
            }
        }
    )
)
