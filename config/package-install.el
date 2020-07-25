(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

(defvar bundle-package-list
  '(
    actionscript-mode
    auto-complete
    coffee-mode
    dash
    direx
    erlang
    esup
    gh
    gist
    go-autocomplete
    go-mode
    go-eldoc
    company-go
    haml-mode
    init-loader
    jade-mode
    js2-mode
    js2-refactor
    json-mode
    json-reformat
    json-snatcher
    less-css-mode
    log4e
    logito
    markdown-mode
    markdown-mode+
    multiple-cursors
    nginx-mode
    org
    ox-gfm
    pcache
    popup
    popwin
    robe
    s
    scss-mode
    slim-mode
    sws-mode
    tuareg
    tss
    w3m
    web-mode
    yagist
    yaml-mode
    yaxception
    zlc
    enh-ruby-mode
    ;;point-undo
    flycheck
    rust-mode
    racer
    flycheck-rust
    ripgrep
    highlight-numbers-mode
    highlight-quoted-mode
    ))

(defun bundle-install ()
  "package install from list"
  (interactive)
  (package-refresh-contents)
  (dolist (package bundle-package-list)
    (when (not (package-installed-p package))
      (package-install package))))
