#!/usr/bin/env bash
set -x
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
    cp $cp_options tmux.conf $HOME/.tmux.conf
}

setup_csh() {
    cp $cp_options cshrc $HOME/.cshrc
}

setup_git() {
    cp $cp_options gitignore $HOME/.gitignore
    gitignore=$HOME/.gitignore
    git config --global core.excludesfile $gitignore
}

setup_bash() {
    cp $cp_options inputrc $HOME/.inputrc
    first_line=$(head -n 1 bashrc)
    if ! grep -q -F "$first_line" $HOME/.bashrc; then
        append_with_newline bashrc $HOME/.bashrc
        mkdir -p $HOME/.shellrc/bashrc.d
    fi
}

append_with_newline() {
    # Append file $1 to file $2 with a newline in between
    echo "$(awk 'FNR==1{print ""}1' $1)" >> $2
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

#setup_vim
#setup_tmux
#setup_git
setup_bash
#setup_csh
