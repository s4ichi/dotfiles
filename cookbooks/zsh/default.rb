package 'zsh'

execute "mkdir -p #{ENV['HOME']}/.zsh/functions" do
  not_if "ls #{ENV['HOME']}/.zsh/functions"
end

execute "touch #{ENV['HOME']}/.zsh/00-machine.zsh" do
  not_if "ls #{ENV['HOME']}/.zsh/00-machine.zsh"
end

ln '.zsh/ext-peco.zsh'
ln '.zsh/ext-kubernetes.zsh'
ln '.zshrc'
