directory "#{ENV['HOME']}/bin" do
  owner node[:user]
end

include_cookbook 'functions'
include_cookbook 'claude-marketplace'
