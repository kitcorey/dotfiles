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

# Ensure ~/.local/bin is in PATH for user-installed binaries
export PATH="$HOME/.local/bin:$PATH"

# Trust internal homelab CA for Node.js (used by Claude Code MCP, etc.).
# Cert is installed by the dotfiles ansible role; system tools pick it up
# from the OS trust store, but Node has its own bundle and needs this var.
export NODE_EXTRA_CA_CERTS="$HOME/.local/share/internal-ca.crt"

# Shims first, then prompt — starship init must come last so its precmd hook runs after mise's.
command -v mise >/dev/null && eval "$(mise activate zsh)"

# Tint the tmux pane when DEPLOY_ENV points at staging/prod. Colors are
# gruvbox red/orange blended 20% into bg0 (#282828). Pane option @env records
# the applied tint; it's read back on each prompt rather than cached in the
# shell because nested shells share the pane.
_tmux_env_color() {
  [[ -n $TMUX ]] || return
  local style env
  case ${DEPLOY_ENV:-} in
    prod|production) style='bg=#492726' env=prod ;;
    staging|stage)   style='bg=#4b3323' env=staging ;;
    *)               style='' env='' ;;
  esac
  [[ $env == "$(tmux display -p -t "$TMUX_PANE" '#{@env}')" ]] && return
  if [[ -n $style ]]; then
    tmux set -p -t "$TMUX_PANE" window-style "$style" \; \
         set -p -t "$TMUX_PANE" window-active-style "$style" \; \
         set -p -t "$TMUX_PANE" @env "$env"
  else
    tmux set -pu -t "$TMUX_PANE" window-style \; \
         set -pu -t "$TMUX_PANE" window-active-style \; \
         set -pu -t "$TMUX_PANE" @env
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _tmux_env_color

# Keep last: see the note above the mise line.
eval "$(starship init zsh)"
