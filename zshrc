export PATH=/opt/homebrew/bin:$PATH
# Ensure Homebrew env is set up before zshrc.d/* (some shells skip ~/.zprofile).
# Guards: only on hosts where brew exists, and skip if .zprofile already ran.
[[ -x /opt/homebrew/bin/brew ]] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]] && \
  eval "$(/opt/homebrew/bin/brew shellenv)"

# Load all files from .shell/zshrc.d directory
if [ -d $HOME/.shellrc/zshrc.d ]; then
  for file in $HOME/.shellrc/zshrc.d/*.zsh(N); do
    source $file
  done
fi

# Use emacs keybindings
bindkey -e

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ensure ~/.local/bin is in PATH for user-installed binaries
export PATH="$HOME/.local/bin:$PATH"

# Trust internal homelab CA for Node.js (used by Claude Code MCP, etc.).
# Cert is installed by the dotfiles ansible role; system tools pick it up
# from the OS trust store, but Node has its own bundle and needs this var.
export NODE_EXTRA_CA_CERTS="$HOME/.local/share/internal-ca.crt"

# Shims first, then prompt — starship init must come last so its precmd hook runs after mise's.
command -v mise >/dev/null && eval "$(mise activate zsh)"
eval "$(starship init zsh)"
