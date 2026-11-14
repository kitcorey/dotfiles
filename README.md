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
([ansible#85837](https://github.com/ansible/ansible/issues/85837)), so
`site.yml` automatically uses the classic sudo (`/usr/bin/sudo.ws`) wherever
it's installed. If become tasks time out waiting for a password prompt,
`sudo.ws` is probably missing; install it with `apt install sudo`.

Add `--check --diff` for a dry run.

Each role has a tag with its own name (`dotfiles`, `nfs_mounts`, `laptop`,
`firebreak`, `aerc`), so you can run a single piece on its own:

```bash
ansible-playbook site.yml -t aerc --ask-become-pass
ansible-playbook site.yml -t laptop,firebreak --ask-become-pass
ansible-playbook site.yml --skip-tags dotfiles --ask-become-pass
```

Host profiles and `local.yml` still load under `-t` (those tasks are tagged
`always`). `--list-tags` shows the tags.

To also install RVM:

```bash
ansible-playbook site.yml --ask-become-pass -e install_rvm=true
```

## What it installs

- **Neovim** — latest AppImage (Linux) or via Homebrew (macOS)
- **zsh** — set as default shell (Linux)
- **mise** — tool version manager (apt/dnf on Linux, Homebrew on macOS). Installs
  the tools in `mise-config.toml`: starship, ripgrep, zoxide, aichat, hk,
  shellcheck, yamllint, go, node, python and the TypeScript LSP
- **gh**, **gitleaks**, **Bitwarden CLI**, **tree-sitter CLI**
- **fzf** — fuzzy finder, cloned to `~/.fzf`
- **tmux** + tpm (plugin manager)
- **vim-plug** — Vim plugin manager
- **Internal CA** — homelab CA cert added to system trust
- **Firefox** (opt-in, Ubuntu) — `firefox_mozilla_deb` in the laptop role installs
  Mozilla's deb from packages.mozilla.org, with unattended upgrades. Moving the
  snap's profile and removing the snap are manual

- **aerc** (opt-in, Linux) — terminal mail client with vim keys, composing in neovim.
  See [Mail (aerc)](#mail-aerc)

## Git hooks

[hk](https://hk.jdx.dev) runs the hooks in `hk.pkl`; `~/.gitconfig` registers
them for every repo, and `HK=0` turns them off.

- **pre-commit:** gitleaks on staged changes, trailing whitespace, final
  newlines, merge-conflict markers, `zsh -n`, shellcheck and yamllint
- **commit-msg:** subject must be `area: summary` (merges, reverts and
  `fixup!`/`squash!` commits are allowed)
- **pre-push:** gitleaks on the full history and `ansible-playbook
  --syntax-check site.yml` when the playbook, roles or host profiles change

Run everything by hand with `hk check --all`, and auto-fix whitespace with
`hk fix --all`.

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

### Mail (aerc)

The `aerc` role installs aerc and w3m, symlinks `aerc/aerc.conf` and
`aerc/binds.conf` into `~/.config/aerc`, and writes `accounts.conf` (mode 0600)
from `aerc_accounts`. Accounts go in `~/.config/dotfiles/local.yml`, which is not
committed:

```yaml
aerc_real_name: Your Name
aerc_accounts:
  - name: iCloud
    provider: icloud
    address: you@icloud.com
    password_cmd: op read 'op://Private/iCloud Mail aerc/password'
  - name: Gmail
    provider: gmail
    address: you@gmail.com
    password_cmd: op read 'op://Private/Gmail aerc/password'
```

Both providers need an **app-specific password**, saved in 1Password under
the item named in `password_cmd`:

- iCloud: account.apple.com → Sign-In and Security → App-Specific Passwords
- Gmail: myaccount.google.com/apppasswords (needs 2-Step Verification)

aerc runs `password_cmd` each time it connects, so no password is written to
disk. Server and folder settings per provider are in
`roles/aerc/defaults/main.yml`. Then run `ansible-playbook site.yml -t aerc
--ask-become-pass`.
