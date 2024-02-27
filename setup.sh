#!/usr/bin/env bash
usage() { echo "Usage: $0 [-o force overwrite]" 1>&2; exit 1; }

setup_vim() {
    destination=$HOME/.vim/autoload/plug.vim
    created=false
    if [ ! -d "$destination" ] ; then
        curl -fLo $destination --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        created=true
    fi
    if [ $overwrite = true ] || [ $created = true ] ; then
        #Install all vundle plugins
        ln -s $(pwd)/vimrc $HOME/.vimrc
        vim +PlugInstall +qall
    fi

    mkdir -p $HOME/.config
    cp $cp_options flake8 $HOME/.config/flake8

    if [ $overwrite = true ] || [ ! -d "$HOME/.config/nvim" ] ; then
        mkdir -p $HOME/.config/nvim
        ln -s $(pwd)/nvim/init.vim $HOME/.config/nvim/init.vim
        ln -s $(pwd)/nvim/lua $HOME/.config/nvim/lua
        ln -s $(pwd)/nvim/plugins $HOME/.config/nvim/plugins
    fi
}

setup_pyenv() {
    destination=$HOME/.pyenv
    if [ ! -d "$destination" ] ; then
        git clone https://github.com/pyenv/pyenv.git $destination
    fi
}

setup_starship() {
    if [ $overwrite = true ] || [ $created = true ] ; then
        #Install all vundle plugins
        mkdir -p $HOME/.config
        ln -s $(pwd)/starship.toml $HOME/.config/starship.toml
    fi
}

setup_tmux() {
    declare plugins_destination=$HOME/.tmux/plugins/tpm
    declare tmux_conf=$HOME/.tmux.conf
    if [ ! -d "$plugins_destination" ] ; then
        git clone https://github.com/tmux-plugins/tpm $plugins_destination
    fi
    if [ ! -e $tmux_conf ] ; then
        ln -s $(pwd)/tmux.conf $tmux_conf
    fi
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
    gitconfig=$HOME/.gitconfig
    if [ ! -e $gitconfig ] || [ $overwrite = true ] ; then
        touch $gitconfig
        append_if_new gitconfig $gitconfig
    fi
}

setup_bash() {
    cp $cp_options inputrc $HOME/.inputrc
    declare bashrc="$HOME/.bashrc"
    declare bashrc_d="$HOME/.shellrc/bashrc.d"
    if [ ! -e $bashrc ] || [ $overwrite = true ] ; then
        mkdir -p ${bashrc_d}
        ln -s $(pwd)/bashrc.d/* ${bashrc_d}
        append_if_new bashrc $bashrc
    fi
}

setup_zsh() {
    declare zshrc="$HOME/.zshrc"
    declare zshrc_d="$HOME/.shellrc/zshrc.d"
    if [[ ! -e $zshrc || $overwrite = true ]] ; then
        mkdir -p ${zshrc_d}
        ln -s $(pwd)/zshrc.d/* ${zshrc_d}
        append_if_new zshrc $zshrc
    fi
}

setup_repos() {
    mkdir -p $HOME/repos/github
}

setup_fzf() {
    destination=$HOME/.fzf
    if [ ! -d "$destination" ] ; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "${destination}"
        cd "${destination}" && git pull && ./install --bin && cd -
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
        return 0
    else
        return 1
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
setup_starship
setup_tmux
setup_git
setup_bash
setup_csh
setup_zsh
setup_repos
setup_fzf
setup_pyenv
