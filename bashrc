# Load all files from .shell/bashrc.d directory
shopt -s nullglob
if [ -d $HOME/.shellrc/bashrc.d ]; then
  for file in $HOME/.shellrc/bashrc.d/*.bash; do
    source $file
  done
fi
shopt -u nullglob
