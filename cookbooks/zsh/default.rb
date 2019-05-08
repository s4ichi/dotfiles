package 'zsh'

directory "#{ENV['HOME']}/.zsh/" do
  owner node[:user]
end

directory "#{ENV['HOME']}/.zsh/functions" do
  owner node[:user]
end

file "#{ENV['HOME']}/.zsh/00-machine.zsh" do
  not_if "test -e #{ENV['HOME']}/.zsh/00-machine.zsh"
  owner node[:user]
  content '# THEME_COLOR=raspberry'
end

ln '.zsh/before'
ln '.zsh/after'
ln '.zshrc'
