# Load all files from .shell/bashrc.d directory
if [ -d $HOME/.shellrc/bashrc.d ]; then
  for file in $HOME/.shellrc/bashrc.d/*.bash; do
    source $file
  done
fi
