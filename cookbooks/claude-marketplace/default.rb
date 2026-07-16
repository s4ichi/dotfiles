node.reverse_merge!(
  claude_marketplace: {
    name: 's4ichi',
    plugins: ['s4ichi'], # install 対象。plugin を増やしたらここに追加
  },
)

repo_root       = File.expand_path('../../..', __FILE__)
marketplace_dir = File.join(repo_root, 'cookbooks', 'claude-marketplace', 'files')
home            = ENV['HOME']
mp_name         = node[:claude_marketplace][:name]
markets_state   = "#{home}/.claude/plugins/known_marketplaces.json"
plugins_state   = "#{home}/.claude/plugins/installed_plugins.json"

execute "HOME='#{home}' claude plugin marketplace add '#{marketplace_dir}'" do
  user node[:user]
  only_if 'command -v claude'
  not_if "test -f '#{markets_state}' && grep -q '\"#{mp_name}\"' '#{markets_state}'"
end

node[:claude_marketplace][:plugins].each do |plugin|
  execute "HOME='#{home}' claude plugin install '#{plugin}@#{mp_name}' --scope user" do
    user node[:user]
    only_if 'command -v claude'
    not_if "test -f '#{plugins_state}' && grep -q '#{plugin}@#{mp_name}' '#{plugins_state}'"
  end
end
