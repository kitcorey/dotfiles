# make ls better
declare color="--color=auto"
# shellcheck disable=SC2139 # expand $color now, on purpose
alias ls="ls $color"
alias la="ls -aF"
alias ld="ls -ld"
alias ll="ls -l"

# reload bash config
alias src="source ~/.bashrc"
