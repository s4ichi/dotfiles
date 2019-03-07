include_role 'base'

include_cookbook 'git'
include_cookbook 'zsh'
include_cookbook 'tmux'
include_cookbook 'emacs'
include_cookbook 'peco'

execute 'defaults write -g InitialKeyRepeat -int 13'
execute 'defaults write -g KeyRepeat -int 1'
