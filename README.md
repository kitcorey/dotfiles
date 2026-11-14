# dotfiles

Personal configuration files for a consistent dev environment across machines.

## Prerequisites

```bash
./bootstrap-ansible.sh
```

This installs Ansible via apt/dnf (Linux) or Homebrew (macOS).

## Usage

```bash
ansible-playbook site.yml --ask-become-pass
```

On Ubuntu 25.10+, Ansible's become doesn't work with the default `sudo-rs`
([ansible#85837](https://github.com/ansible/ansible/issues/85837)); use the
classic sudo instead:

```bash
ANSIBLE_BECOME_EXE=sudo.ws ansible-playbook site.yml --ask-become-pass
```

Add `--check --diff` for a dry run.

To also install RVM:

```bash
ansible-playbook site.yml --ask-become-pass -e install_rvm=true
```

## What it installs

- **Neovim** — latest AppImage (Linux) or via Homebrew (macOS)
- **zsh** — set as default shell (Linux)
- **mise** — tool version manager (apt/dnf on Linux, Homebrew on macOS). Installs
  the tools in `mise-config.toml`: starship, ripgrep, zoxide, aichat, hk, go,
  node, python and the TypeScript LSP
- **gh**, **gitleaks**, **Bitwarden CLI**, **tree-sitter CLI**
- **fzf** — fuzzy finder, cloned to `~/.fzf`
- **tmux** + tpm (plugin manager)
- **vim-plug** — Vim plugin manager
- **Internal CA** — homelab CA cert added to system trust
- **Firefox** (opt-in, Ubuntu) — `firefox_mozilla_deb` in the laptop role installs
  Mozilla's deb from packages.mozilla.org, with unattended upgrades. Moving the
  snap's profile and removing the snap are manual

## Dotfiles managed

Symlinks created in `$HOME`:

- `.zshrc`, `.zshenv`, `.shellrc/zshrc.d`, `.shellrc/bashrc.d`
- `.vimrc`, `.config/nvim/init.vim`, `.config/nvim/lua`
- `.tmux.conf`
- `.gitconfig`, `.gitignore`
- `.config/starship.toml`, `.config/mise/config.toml`
- `<user-config-dir>/aichat`

Copied (not symlinked): `.cshrc`, `.inputrc`, `.config/flake8`

### aichat API keys

The aichat `config.yaml` does not contain API keys. Create `aichat/.env` in this repo (gitignored) with your credentials:
```
ANTHROPIC_API_KEY=sk-ant-...
```
