if ! command -v zoxide &> /dev/null; then
    PATH="$PATH:$HOME/.local/bin"
fi

if command -v zoxide &> /dev/null; then
	eval "$(zoxide init bash --cmd cd)"
fi
