;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)


;; Disable builtin-packages that installed by doom-emacs
;; This required to run: doom refresh
(package! undo-tree :disable t)
(package! gitconfig-mode :disable t)
(package! gitignore-mode :disable t)
;;(package! smartparens :disable t)

(package! dockerfile-mode)
(package! hydra)
(package! which-key)
(package! ace-window)
(package! nginx-mode)
(package! yaml-mode)
(package! tuareg)
(package! auto-complete)
(package! enh-ruby-mode)
(package! robe)
(package! yard-mode)
(package! markdown-mode)
(package! markdown-mode+)
(package! jsonnet-mode)
(package! protobuf-mode)
(package! go-mode)
(package! go-eldoc)
(package! rust-mode)
(package! rustic)
(package! lsp-mode)
(package! lsp-ui)
(package! flycheck)
(package! bpftrace-mode)
(package! js2-mode)
(package! rjsx-mode)
(package! typescript-mode)
(package! tide)
(package! prettier-js)
(package! rg)
(package! kotlin-mode)
(package! jq-format)
(package! rego-mode)

(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
