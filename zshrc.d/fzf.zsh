# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kit/.fzf/bin* ]]; then
  export PATH="$PATH:/home/kit/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kit/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/kit/.fzf/shell/key-bindings.zsh"

