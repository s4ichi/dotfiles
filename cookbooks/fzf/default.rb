node.reverse_merge!(
  fzf: {
    version: '0.18.0',
  },
)

github_binary 'fzf' do
  repository 'junegunn/fzf-bin'
  version node[:fzf][:version]
  archive "fzf-#{node[:fzf][:version]}-#{node[:os]}_amd64.tgz"
  binary_path "fzf"
end
