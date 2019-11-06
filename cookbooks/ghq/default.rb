github_binary 'ghq' do
  repository 'motemen/ghq'
  version 'v0.12.8'
  archive "ghq_#{node[:os]}_amd64.zip"
  binary_path "ghq_#{node[:os]}_amd64/ghq"
end
