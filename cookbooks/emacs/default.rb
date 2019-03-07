if node[:platform] == 'darwin'
  package 'emacs'
else
  package 'emacs25-nox'
end

execute "mkdir -p #{ENV['HOME']}/.emacs/themes" do
  not_if "ls #{ENV['HOME']}/.emacs.d/themes"
end

execute "mkdir -p #{ENV['HOME']}/.emacs/elisp" do
  not_if "ls #{ENV['HOME']}/.emacs.d/elisp"
end

ln '.emacs'
ln '.emacs.d/inits'
ln '.emacs.d/themes/dark-laptop-theme.el'
ln '.emacs.d/themes/sky-color-clock.el'

package_install_el = File.expand_path("./package-install.el", __FILE__)
execute "emacs --batch -q -l #{package_install_el.to_s} -f 'bundle-install'"
