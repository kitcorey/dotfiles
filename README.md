# dotfiles

Personal configuration files for a consistent dev environment across machines.

## Prerequisites

```bash
pip install ansible
ansible-galaxy collection install community.general
```

## Usage

```bash
ansible-playbook site.yml --ask-become-pass
```

To also install RVM:

```bash
ansible-playbook site.yml --ask-become-pass -e install_rvm=true
```

## What it installs

- **Neovim** — latest AppImage (Linux) or via Homebrew (macOS)
- **zsh** — set as default shell (Linux)
- **starship** — prompt, built from source via cargo (Linux) or Homebrew (macOS)
- **zoxide**, **ripgrep**, **fzf** — modern shell utilities
- **pyenv** + **pyenv-virtualenv** — Python version management
- **tmux** + tpm (plugin manager)
- **Rust** / cargo — via rustup (Linux) or Homebrew (macOS)
- **vim-plug** — Vim plugin manager

## Dotfiles managed

Symlinks created in `$HOME`:

- `.zshrc`, `.shellrc/zshrc.d`, `.shellrc/bashrc.d`
- `.vimrc`, `.config/nvim/init.vim`, `.config/nvim/lua`
- `.tmux.conf`
- `.gitconfig`, `.gitignore`
- `.config/starship.toml`

Copied (not symlinked): `.cshrc`, `.inputrc`, `.config/flake8`
