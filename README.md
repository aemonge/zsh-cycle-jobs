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
