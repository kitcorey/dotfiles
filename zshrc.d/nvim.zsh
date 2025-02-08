if ! command -v nvim 2>&1 >/dev/null
then
    PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi
alias vi=nvim
