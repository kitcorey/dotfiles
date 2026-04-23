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

# Trust internal step-ca for Node.js (used by Claude Code MCP, etc.)
export NODE_EXTRA_CA_CERTS="$HOME/docker/step-ca/data/step-ca/certs/root_ca.crt"

# Starting the starship prompt should be done last
eval "$(starship init zsh)"
