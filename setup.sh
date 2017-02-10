#!/usr/bin/env bash
usage() { echo "Usage: $0 [-o force overwrite]" 1>&2; exit 1; }

setup_vim() {
    destination=~/.vim/bundle/Vundle.vim
    if [ ! -d "$destination" ] ; then
        git clone https://github.com/VundleVim/Vundle.vim.git $destination
    fi
    cp $cp_options vimrc ~/.vimrc
}

setup_tmux() {
    destination=~/.tmux/plugins/tpm
    if [ ! -d "$destination" ] ; then
        git clone https://github.com/tmux-plugins/tpm $destination
    fi
    cp $cp_options tmux.conf ~/.tmux.conf
}

setup_git() {
    cp $cp_options gitignore ~/.gitignore
    gitignore=~/.gitignore
    git config --global core.excludesfile $gitignore
}


cp_options="--no-clobber"
while getopts ":o" o; do
    case "${o}" in
        o)
            echo "HI"
            cp_options=""
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
