# Disable flow control so C-s can be used to search forward (interactive shell only)
[[ $- == *i* ]] && stty -ixon

# Configure the shell to always append to history
shopt -s histappend

# History will ignore duplicate commands and lines starting with space
export HISTCONTROL=ignoreboth
