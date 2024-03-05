if [ -f ~/.fzf.bash ]; then
	export PATH="$PATH:$HOME/.fzf/bin"
	source ~/.fzf.bash
	#alias themes="ls ~/.config/alacritty/themes/themes | fzf | xargs -I {} ln -sf ~/.config/alacritty/themes/themes/{} ~/.config/alacritty/current_theme.toml && echo "@@@" >> ~/.config/alacritty/alacritty.yml && sed -i '/@@@/d' ~/.config/alacritty/alacritty.yml"
fi
