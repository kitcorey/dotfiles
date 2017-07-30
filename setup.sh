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
        ln -s $(pwd)/vimrc $HOME/.vimrc
        vim +PluginInstall +qall
    fi

    mkdir -p $HOME/.config
    cp $cp_options flake8 $HOME/.config/flake8
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
    git config --global core.excludesfile $gitignore
    git config --global user.email kitcorey@users.noreply.github.com
    git config --global user.name "Kit Corey"
    git config --global  alias.lg 'log --graph --oneline --decorate --all'
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
        # Install oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        curl https://raw.githubusercontent.com/oskarkrawczyk/honukai-iterm/master/honukai.zsh-theme -o $HOME/.oh-my-zsh/themes/honukai.zsh-theme

        # Add zsh-dircolors as a plugin to oh-my-zsh
        declare ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
        git clone git://github.com/joel-porquet/zsh-dircolors-solarized $ZSH_CUSTOM/plugins/zsh-dircolors-solarized
    fi
}

setup_repos() {
    mkdir -p $HOME/repos/github
}

setup_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin
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
setup_tmux
setup_git
setup_bash
setup_csh
setup_zsh
setup_repos
setup_fzf
