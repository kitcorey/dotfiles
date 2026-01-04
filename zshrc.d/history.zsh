# See this stackoverflow post for information on why these settings were chosen
# https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history
#
# Don't store duplicates, erase any existing ones
# Immediately share history with all open terminals
# Always append history, don't overwrite it
# Store multiline commands as a single command
#
#export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                   # custom history size
export HISTFILESIZE=100000              # custom history file size
export SAVEHIST=100000
export HISTFILE=~/.zsh_history
setopt appendhistory      # Append history lines to the file (instead of overwriting)
setopt share_history      # Share history among all open zsh sessions
setopt extended_history   # Record the time when each command was executed
setopt hist_ignore_all_dups   # Do not enter a command into the history list if it is a duplicate of the previous one

#PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
