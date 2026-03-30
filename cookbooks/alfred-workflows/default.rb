alfred_workflows_dir = "#{ENV['HOME']}/.config/alfred-workflows"

directory alfred_workflows_dir do
  owner node[:user]
end

workflows_src_dir = File.expand_path('..', __FILE__)
Dir.glob("#{workflows_src_dir}/*/").each do |workflow_dir|
  workflow_name = File.basename(workflow_dir)
  dest      = "#{alfred_workflows_dir}/#{workflow_name}.alfredworkflow"
  hash_file = "#{alfred_workflows_dir}/.#{workflow_name}.sha"
  hash_cmd  = "cd '#{workflow_dir}' && find . -type f -not -name .DS_Store | sort | xargs shasum | shasum | cut -c1-40"

  execute "cd '#{workflow_dir}' && zip -r '#{dest}' . -x '*.DS_Store' && open '#{dest}' && #{hash_cmd} > '#{hash_file}'" do
    not_if "test -f '#{hash_file}' && [ \"$(#{hash_cmd})\" = \"$(cat '#{hash_file}')\" ]"
  end
end
