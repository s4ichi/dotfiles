alfred_workflows_dir = "#{ENV['HOME']}/.config/alfred-workflows"

directory alfred_workflows_dir do
  owner node[:user]
end

workflows_src_dir = File.expand_path('..', __FILE__)
Dir.glob("#{workflows_src_dir}/*/").each do |workflow_dir|
  workflow_name = File.basename(workflow_dir)
  dest = "#{alfred_workflows_dir}/#{workflow_name}"

  execute "cp -r #{workflow_dir} #{dest}" do
    not_if "test -d #{dest}"
  end
end
