# ZSH Cycle Jobs Plugin

## Description

The ZSH Cycle Jobs Plugin is a simple yet powerful tool that enhances your terminal
workflow by allowing you to cycle through background jobs using a single keyboard
shortcut. This plugin is particularly useful for developers and system administrators
who frequently work with multiple background processes.

[![asciicast](https://asciinema.org/a/687404.svg)](https://asciinema.org/a/687404)

## Features

- Cycle through background jobs using Ctrl+Z
- Automatically handles circular rotation of jobs
- Maintains state between terminal sessions
- Easy to install and use

## Installation (zinit)

```zsh
zinit load aemonge/zsh-cycle-jobs
```

## Usage

Once installed, you can use the plugin by pressing Ctrl+Z while in your terminal. This
will cycle through your background jobs, bringing each one to the foreground in turn.

### How it works

The plugin keeps track of the last accessed job number in a temporary file. When you
press Ctrl+Z, it calculates the next job in the sequence and brings it to the foreground
using the fg command.

## Configuration

No additional configuration is required. The plugin works out of the box.

## Compatibility

This plugin is designed for ZSH and has been tested on Unix-like systems (Linux, macOS).
It may not work correctly on other operating systems.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

#### Author

aemonge

#### Version

0.0.1
