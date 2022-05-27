package 'git'

ln '.gitconfig'
ln '.gitconfig.user'
ln '.gitignore'

file "#{ENV['HOME']}/.gitconfig.local" do
  not_if "test -e #{ENV['HOME']}/.gitconfig.local"
  owner node[:user]
end
