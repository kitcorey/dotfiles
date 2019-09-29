# See this stackoverflow post for information on why these settings were chosen
# https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history
#
# Don't store duplicates, erase any existing ones
# Immediately share history with all open terminals
# Always append history, don't overwrite it
# Store multiline commands as a single command
#
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                   # custom history size
export HISTFILESIZE=100000              # custom history file size
setopt HIST_IGNORE_ALL_DUPS
#PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
