# Setup .pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# This is needed because tk-devel in AL2 does not conform to pkg-config standard so
# configure for CPython3.11+ doesn't detect it properly
export TCLTK_LIBS="-ltk8.5 -ltcl8.5"
