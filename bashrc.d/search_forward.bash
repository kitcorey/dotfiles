# Disable flow control so C-s can be used to search forward (interactive shell only)
[[ $- == *i* ]] && stty -ixon
