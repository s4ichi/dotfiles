directory File.join(ENV['HOME'], '.config/herdr') do
  user node[:user]
end

ln '.config/herdr/config.toml'
