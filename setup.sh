#!/usr/bin/env bash
usage() { echo "Usage: $0 [-o force overwrite]" 1>&2; exit 1; }

setup_vim() {
    destination=$HOME/.vim/bundle/Vundle.vim
    created=false
    if [ ! -d "$destination" ] ; then
        git clone https://github.com/VundleVim/Vundle.vim.git $destination
        created=true
    fi
    if [ $overwrite = true ] || [ $created = true ] ; then
        #Install all vundle plugins
        vim +PluginInstall +qall
    fi
    cp $cp_options vimrc $HOME/.vimrc

    mkdir -p $HOME/.config
    cp $cp_options flake8 $HOME/.config/flake8
}

setup_tmux() {
    destination=$HOME/.tmux/plugins/tpm
    if [ ! -d "$destination" ] ; then
        git clone https://github.com/tmux-plugins/tpm $destination
    fi
    ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
}

setup_csh() {
    cp $cp_options cshrc $HOME/.cshrc
}

setup_git() {
    gitignore=$HOME/.gitignore
    if [ ! -e $gitignore ] || [ $overwrite = true ] ; then
        touch $gitignore
        append_if_new gitignore $gitignore
    fi
    git config --global core.excludesfile $gitignore
}

setup_bash() {
    cp $cp_options inputrc $HOME/.inputrc
    bashrc=$HOME/.bashrc
    if [ ! -e $bashrc ] || [ $overwrite = true ] ; then
        if append_if_new bashrc $bashrc; then
            mkdir -p $HOME/.shellrc/bashrc.d
        fi
    fi
}

append_with_newline() {
    # Append file $1 to file $2 with a newline in between
    if [ $# -ne 2 ]; then
        echo "Not enough arguments provided to $FUNCNAME"
        exit
    fi
    echo "$(awk 'FNR==1{print ""}1' $1)" >> $2
}

append_if_new() {
    # Append file $1 to file $2 if the first line of $1 is not in $2
    first_line=$(head -n 1 bashrc)
    if [ $# -ne 2 ]; then
        echo "Not enough arguments provided to $FUNCNAME"
        exit
    fi
    src=$1
    dst=$2
    first_line=$(head -n 1 $src)
    if ! grep -q -F "$first_line" $dst; then
        append_with_newline $src $dst
        return 1
    else
        return 0
    fi
}

# standard no-clobber option for cp
cp_options="-n"
overwrite=false
while getopts ":o" o; do
    case "${o}" in
        o)
            cp_options=""
            overwrite=true
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

setup_vim
setup_tmux
setup_git
setup_bash
setup_csh
