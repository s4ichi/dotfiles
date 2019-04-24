;;; cargo install racer
;;; rustup component add rustfmt --toolchain nightly-x86_64-unknown-linux-gnu
;;; rustup component add rust-src

;;; rust-mode
(use-package rust-mode
  :defer t
  :config
  (setq rust-format-on-save t))

;;; racer
(use-package racer
  :init
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode))

;;; flycheck-rust
(use-package flycheck-rust
  :init
  (add-hook 'rust-mode-hook
            '(lambda ()
               (flycheck-mode)
               (flycheck-rust-setup))))

;;; company hook
(add-hook 'racer-mode-hook (lambda ()
                             (company-mode)
                             (set (make-variable-buffer-local 'company-idle-delay) 0.1)
                             (set (make-variable-buffer-local 'company-minimum-prefix-length) 0)))
