# dotfiles

My macOS configuration files.

## Contents

- **aerospace** - Tiling window manager
- **ghostty** - Terminal emulator
- **karabiner** - Keyboard customization (Hyper key, Caps Lock → Ctrl)
- **lazygit** - Git TUI
- **nvim** - Neovim config (mini.nvim, nvim-jdtls, markview)
- **sketchybar** - Status bar
- **starship** - Prompt
- **tmux** - Terminal multiplexer
- **zshrc** - Zsh configuration

## Keyboard Layout

Custom QWERTY-like layout (Zenith):
- **keyboard-layout/** - macOS bundle (install to `~/Library/Keyboard Layouts/`)
- [Visualization](https://gist.github.com/kj-111/debf1429f787d6073008502bed5af4e6)

## Installation

```bash
# Clone
git clone https://github.com/kj-111/dotfiles-public.git

# Symlink configs to ~/.config
ln -s /path/to/dotfiles-public/nvim ~/.config/nvim
ln -s /path/to/dotfiles-public/aerospace ~/.config/aerospace
# etc.

# Symlink zshrc
ln -s /path/to/dotfiles-public/zshrc ~/.zshrc

# Symlink starship
ln -s /path/to/dotfiles-public/starship/starship.toml ~/.config/starship.toml
```

## Dependencies

- [Aerospace](https://github.com/nikitabobko/AeroSpace)
- [Ghostty](https://ghostty.org)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [Neovim](https://neovim.io)
- [Sketchybar](https://github.com/FelixKratz/SketchyBar)
- [Starship](https://starship.rs)
- [tmux](https://github.com/tmux/tmux) + [TPM](https://github.com/tmux-plugins/tpm)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [fd](https://github.com/sharkdp/fd)

## License

MIT
