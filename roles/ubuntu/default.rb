node.reverse_merge!(
  emacs: {
    package: {
      name: 'emacs25-nox',
    },
  },
)

include_role 'base'

include_cookbook 'git'
include_cookbook 'zsh'
include_cookbook 'tmux'
include_cookbook 'emacs'
include_cookbook 'peco'
