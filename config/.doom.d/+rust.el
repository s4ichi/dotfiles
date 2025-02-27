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
