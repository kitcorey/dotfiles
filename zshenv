# Keep PATH unique. Applying the -U attribute dedupes the array immediately and
# on every later prepend (here and in .zshrc), so nested shells — tmux, IDE
# terminals, `exec zsh` — don't accumulate duplicate entries. First occurrence
# wins, so priority order is preserved.
typeset -U path PATH

export PATH="$HOME/.local/share/mise/shims:$PATH"
