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

# Prompt and shims — both register precmd hooks, order between them doesn't matter
eval "$(starship init zsh)"
command -v mise >/dev/null && eval "$(mise activate zsh)"
