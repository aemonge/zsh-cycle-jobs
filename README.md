# ZSH Cycle Jobs Plugin

## Description

The ZSH Cycle Jobs Plugin is a simple yet powerful tool that enhances your terminal
workflow by allowing you to select background jobs using an interactive fzf menu. This
plugin is particularly useful for developers and system administrators who frequently
work with multiple background processes.

[![asciicast](https://asciinema.org/a/687404.svg)](https://asciinema.org/a/687404)

## Features

- Interactive selection of background jobs using fzf
- Customizable keyboard shortcut (defaults to Ctrl+J)
- Clean job display with status information
- Easy to install and use
- **Automatic foregrounding when only one job exists**

## Installation (zinit)

```zsh
zinit load aemonge/zsh-cycle-jobs
```

## Usage

Once installed, you can use the plugin by pressing the configured keyboard shortcut
(default is Ctrl+J) while in your terminal. This will display an fzf menu of your
background jobs, allowing you to select which one to bring to the foreground.

If only one background job exists, it will be automatically brought to the foreground
without showing the fzf menu.

### How it works

The plugin uses the `jobs -l` command to list all background jobs, then presents them in
an interactive fzf menu. When you select a job, it brings it to the foreground using the
`fg` command.

### Customization

You can customize the keyboard shortcut by setting the `FZF_JOB_KEYBIND` environment
variable before loading the plugin:

```zsh
# Use Ctrl+Z instead of default Ctrl+J
export FZF_JOB_KEYBIND="^Z"
zinit load aemonge/zsh-cycle-jobs

# Use Ctrl+G
export FZF_JOB_KEYBIND="^G"
zinit load aemonge/zsh-cycle-jobs
```

### Powerlevel10k Integration

If you use Powerlevel10k, you can display your background jobs as visual tabs in your
prompt.

#### Setup

Add this configuration to your ~/.p10k.zsh:

```bash
#########################################[ job_tabs: ]########################################
# Optimized for Gruvbox Light (Dark Text on Cream Background)
# Ensure the segment has no background (matches your Lean style)
typeset -g POWERLEVEL9K_JOB_TABS_BACKGROUND=none
typeset -g POWERLEVEL9K_JOB_TABS_BRACKET_FOREGROUND=12
typeset -g POWERLEVEL9K_JOB_TABS_COMMAND_FOREGROUND=13

# Optional: selected job styling
typeset -g POWERLEVEL9K_JOB_TABS_SELECTED_FOREGROUND=1   # red

function prompt_job_tabs() {
  local -a ids
  ids=("${(@k)jobtexts}")

  if (( ${#ids} == 0 )); then
    return
  fi

  # --- DYNAMIC COLORS (FIXED) ---
  # 1. Read the Bracket color from config (Default: 240)
  local b_col="${POWERLEVEL9K_JOB_TABS_BRACKET_FOREGROUND:-240}"

  # 2. Read the Command color from config (Default: 0)
  local c_col="${POWERLEVEL9K_JOB_TABS_COMMAND_FOREGROUND:-0}"

  # 3. Create formatting strings
  local c_bracket="%F{${b_col}}"
  local c_sep="%F{${b_col}}"       # Separator uses same color as bracket
  local c_cmd="%F{${c_col}}"
  local c_reset="%f"

  # Build the list content
  local list=""
  for id in $ids; do
    # Get command, strip '&'
    local cmd="${jobtexts[$id]%%&*}"
    cmd="${cmd% }"

    # Add separator if not first item
    if [[ -n "$list" ]]; then
      list="${list}${c_sep}, ${c_reset}"
    fi

    # Just the Name (No ID numbers)
    list="${list}${c_cmd}${cmd}${c_reset}"
  done

  # Wrap in [ ... ]
  local final_content="${c_bracket}[ ${c_reset}${list} ${c_bracket}]${c_reset}"

  p10k segment -t "$final_content"
}
```

Then add job_tabs to your prompt elements:

```bash
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  # ....
  job_tabs
  # ....
)
```

Color customization: Run this command to see all available colors and pick your
favorites:

```bash
for i in {0..255}; do print -Pn "%K{$i} %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
```

## Requirements

- ZSH shell
- [fzf](https://github.com/junegunn/fzf) must be installed

## Compatibility

This plugin is designed for ZSH and has been tested on Unix-like systems (Linux, macOS).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

#### Author

aemonge

#### Version

0.0.3
