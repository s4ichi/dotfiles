;;; cargo install racer
;;; rustup component add rustfmt --toolchain nightly-x86_64-unknown-linux-gnu
;;; rustup component add rust-src

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
   (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)
  (remove-hook 'before-save-hook 'delete-trailing-whitespace t))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
   ("C-n". company-select-next)
   ("C-p". company-select-previous)
   ("M-<". company-select-first)
   ("M->". company-select-last)))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

;; ;;; rust-mode
;; (use-package rust-mode
;;   :defer t
;;   :config
;;   (setq rust-format-on-save t))

;; ;;; racer
;; (use-package racer
;;   :init
;;   (add-hook 'rust-mode-hook #'racer-mode)
;;   (add-hook 'racer-mode-hook #'eldoc-mode))

;; ;;; flycheck-rust
;; (use-package flycheck-rust
;;   :init
;;   (add-hook 'rust-mode-hook
;;             '(lambda ()
;;                (flycheck-mode)
;;                (flycheck-rust-setup))))

;; ;;; company hook
;; (add-hook 'racer-mode-hook (lambda ()
;;                              (company-mode)
;;                              (set (make-variable-buffer-local 'company-idle-delay) 0.1)
;;                              (set (make-variable-buffer-local 'company-minimum-prefix-length) 0)))
