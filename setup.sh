#!/usr/bin/env bash
usage() { echo "Usage: $0 [-o force overwrite]" 1>&2; exit 1; }

setup_vim() {
    destination=~/.vim/bundle/Vundle.vim
    created=false
    if [ ! -d "$destination" ] ; then
        git clone https://github.com/VundleVim/Vundle.vim.git $destination
        created=true
    fi
    if [ $overwrite = true ] || [ $created = true ] ; then
        #Install all vundle plugins
        vim +PluginInstall +qall
    fi
    cp $cp_options vimrc ~/.vimrc

    mkdir -p ~/.config
    cp $cp_options flake8 ~/.config/flake8
}

setup_tmux() {
    destination=~/.tmux/plugins/tpm
    if [ ! -d "$destination" ] ; then
        git clone https://github.com/tmux-plugins/tpm $destination
    fi
    cp $cp_options tmux.conf ~/.tmux.conf
}

setup_csh() {
    cp $cp_options cshrc ~/.cshrc
}

setup_git() {
    cp $cp_options gitignore ~/.gitignore
    gitignore=~/.gitignore
    git config --global core.excludesfile $gitignore
}

setup_bash() {
    cp $cp_options inputrc ~/.inputrc
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
