if ! which fzf > /dev/null; then
	return
fi

# global aliases
alias -g B='`git branch | fzf | sed -e "s/^\*[ ]*//g"`'
alias -g P='| fzf | xargs '

# history
function fzf-select-history() {
	BUFFER=$(fc -l -r -n 1 | fzf --height 40% --border --query "$LBUFFER" --prompt "[zsh history] > ")
	CURSOR=$#BUFFER
	zle redisplay
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# integrate all source code with ghq
function fzf-src() {
	local selected_dir=$(ghq list | fzf --height 40% --border --query "$LBUFFER" --prompt "[ghq list] > ")
	if [ -n "$selected_dir" ]; then
		full_dir="${HOME}/src/${selected_dir}"

		# Log repository access to ghq-cache
		# (ghq-cache log $full_dir &)

		BUFFER="cd ${full_dir}"
		zle accept-line
	fi
	zle redisplay
}
zle -N fzf-src
stty -ixon
bindkey '^s' fzf-src

# process kill
function fzf-pkill() {
	for pid in `ps aux | fzf --border | awk '{ print $2 }'`
	do
		kill $pid
		echo "Killed ${pid}"
	done
}
alias pk="fzf-pkill"

# search file recursively and append the path to the buffer
function fzf-find-file() {
	if git rev-parse 2> /dev/null; then
		source_files=$(git ls-files)
	else
		source_files=$(find . -type f)
	fi
	selected_files=$(echo $source_files | fzf --height 40% --border --prompt "[find file] > ")

	BUFFER="${BUFFER}$(echo $selected_files | tr '\n' ' ')"
	CURSOR=$#BUFFER
	zle redisplay
}
zle -N fzf-find-file
bindkey '^q' fzf-find-file
