node.reverse_merge!(
  fzf: {
    version: '0.67.0',
  },
)

github_binary 'fzf' do
  repository 'junegunn/fzf'
  version "v#{node[:fzf][:version]}"
  archive "fzf-#{node[:fzf][:version]}-#{node[:os]}_arm64.tar.gz"
  binary_path "fzf"
end
