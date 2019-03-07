package node[:emacs][:package][:name]

directory "#{ENV['HOME']}/.emacs.d" do
  owner node[:user]
end

directory "#{ENV['HOME']}/.emacs.d/themes" do
  owner node[:user]
end

directory "#{ENV['HOME']}/.emacs.d/elisp" do
  owner node[:user]
end

ln '.emacs'
ln '.emacs.d/inits'
ln '.emacs.d/themes/dark-laptop-theme.el'
ln '.emacs.d/themes/sky-color-clock.el'

package_install_el = File.expand_path("../package-install.el", __FILE__)
execute "emacs --batch -q -l #{package_install_el.to_s} -f 'bundle-install'"
