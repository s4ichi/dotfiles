# inits
for f in $(ls ${HOME}/.zsh/*.zsh | sort); do
    source $f
done

# theme

if [ -z $THEME_COLOR ]; then
    THEME_COLOR=blue
fi

case $THEME_COLOR in
    sumire    ) THEME_COLOR=141-26;;
    kazesawa  ) THEME_COLOR=32-93;;
    sakura    ) THEME_COLOR=76-212;;
    ran       ) THEME_COLOR=124-90;;
    orange    ) THEME_COLOR=166-172;;
    green     ) THEME_COLOR=28-35;;
    blue      ) THEME_COLOR=25-31;;
    sky       ) THEME_COLOR=32-39;;
    red       ) THEME_COLOR=124-160;;
    raspberry ) THEME_COLOR=125-126;;
    pink      ) THEME_COLOR=198-199;;
    purple    ) THEME_COLOR=90-91;;
    gray      ) THEME_COLOR=240-242;;
esac

export COLOR_DARK=${THEME_COLOR%-*}
export COLOR_LIGHT=${THEME_COLOR#*-}

# profile
PROFILE_DEFAULT_USER=eveysick
PROFILE_DEFAULT_HOST=EVERYSICK

# color
autoload colors
colors

# prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '#%b'
zstyle ':vcs_info:*' actionformats '#%b|%a'
PR_TIME="%B%K{$COLOR_DARK} %D{%H:%M:%S} %k%b"
PR_USER="%B%K{$COLOR_LIGHT} %n %k%b"
PR_HOST="%B%K{$COLOR_DARK} %m %k%b"
precmd() {
    ANG=en_US.UTF-8 vcs_info
    PROMPT="%F{$COLOR_DARK}%~%F{$COLOR_LIGHT}${vcs_info_msg_0_}%F{250}%(!.#.$)%f "
    if [ $PROFILE_DEFAULT_HOST != $(hostname -s) ]; then
        PROMPT="${PR_TIME}${PR_USER}${PR_HOST} ${PROMPT}"
    else
        PROMPT="${PR_TIME}${PR_USER} ${PROMPT}"
    fi
}

# completion
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
zstyle ":completion:*:commands" rehash 1

# npm completion
if [ -e "${HOME}/.zsh/npm-completion.bash" ]; then
    source "${HOME}/.zsh/npm-completion.bash"
fi

zstyle ':completion:*:default' menu select=1

setopt auto_pushd
setopt auto_cd
setopt nolistbeep
setopt hist_ignore_space

# history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt hist_ignore_dups
setopt share_history

if [[ "${terminfo[kcuu1]}" != "" ]]; then
    bindkey "${terminfo[kcuu1]}" up-line-or-search
fi
if [[ "${terminfo[kcud1]}" != "" ]]; then
    bindkey "${terminfo[kcud1]}" down-line-or-search
fi

# editor
export EDITOR='emacs'

# key map
bindkey -e

# PATH
which brew > /dev/null 2>&1
if [ $? = 0 ]; then
    export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
fi

export PATH="${PATH}:/usr/local/bin:/usr/local/sbin"
export PATH="${HOME}/bin:${PATH}"
export PATH="${HOME}/.nodebrew/current/bin:${PATH}"
export PATH="${PATH}:./node_modules/.bin"
export PATH="${HOME}/.rbenv/bin:${PATH}"
export PATH="${HOME}/.pyenv/bin:${PATH}"
export PATH="${HOME}/.emacs.d/bin:${PATH}"

# golang
if [ -x "`which go`" ]; then
    export GOROOT="`go env GOROOT`"
    export GOPATH="${HOME}/go"
    export PATH="${GOPATH}/bin:${PATH}"
fi

# rustup
if [ -x "`which rustup`" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# rbenv init
which rbenv > /dev/null 2>&1
if [ $? = 0 ]; then
    eval "$(rbenv init -)"
fi

# pyenv init
which pyenv > /dev/null 2>&1
if [ $? = 0 ]; then
    eval "$(pyenv init -)"
fi

# ls aliases
alias ls='ls'
alias l="ls"
alias la="ls"
alias ll="ls -lah"
alias sl="ls"

export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig"
source "${HOME}/.zsh/ext-peco.zsh"
