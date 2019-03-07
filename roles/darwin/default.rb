node.reverse_merge!(
  initial_key_repeat: 13,
  key_repeat: 1,
  emacs: {
    package: {
      name: 'emacs',
    },
  },
)

include_role 'base'

include_cookbook 'git'
include_cookbook 'zsh'
include_cookbook 'tmux'
include_cookbook 'emacs'
include_cookbook 'peco'

execute "defaults write -g InitialKeyRepeat -int #{node[:initial_key_repeat]}" do
  not_if "test $(defaults read -g InitialKeyRepeat) -eq #{node[:initial_key_repeat]}"
end

execute "defaults write -g KeyRepeat -int #{node[:key_repeat]}" do
  not_if "test $(defaults read -g KeyRepeat) -eq #{node[:key_repeat]}"
end
