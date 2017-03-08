# For gnome and xfce terminals, manually set a 16bit terminal type.
# This works around compatibility issues with Solarized, tmux and vim
# that occur when the number of colors set for xterm and screen do not match
#
# To check the number of colors supported by the current terminal, run:
# tput colors
#
# To see a list of currently supported terminal types, run:
# toe
#
# xterm-16color is not available on all systems.  It is currently
# installed in $HOME/.terminfo
if [ -z $TMUX ] && { [ "$COLORTERM" = "gnome-terminal" ] || [ "$COLORTERM" = "xfce4-terminal" ]; }
then
    export TERM=xterm-16color
fi

# Automatically reattach to an existing session when running tmux
tmux_path=$(type -P tmux)
alias tmux="$tmux_path attach || $tmux_path new"
