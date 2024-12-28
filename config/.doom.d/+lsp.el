(defvar +lsp-company-backends
  (if (modulep! :editor snippets)
      '(:separate company-capf company-yasnippet)
    'company-capf)
  "The backends to prepend to `company-backends' in `lsp-mode' buffers.
Can be a list of backends; accepts any value `company-backends' accepts.")

(use-package lsp-mode
  :commands lsp
  :init
  ;; Don't touch ~/.emacs.d, which could be purged without warning
  (setq lsp-session-file (concat doom-cache-dir "lsp-session")
        lsp-server-install-dir (concat doom-data-dir "lsp"))

  ;; Don't auto-kill LSP server after last workspace buffer is killed, because I
  ;; will do it for you, after `+lsp-defer-shutdown' seconds.
  (setq lsp-keep-workspace-alive nil)

  ;; Disable features that have great potential to be slow.
  (setq lsp-enable-folding nil
        lsp-enable-text-document-color nil)

  ;; Reduce unexpected modifications to code
  (setq lsp-enable-on-type-formatting nil)

  ;; Make breadcrumbs opt-in; they're redundant with the modeline and imenu
  (setq lsp-headerline-breadcrumb-enable nil)

  (setq  lspa-idle-delay 0.2
         lsp-enable-xref t
         lsp-rust-analyzer-cargo-watch-command "clippy"
         lsp-rust-analyzer-server-display-inlay-hints t)

  :config
  (set-lookup-handlers! 'lsp-mode
    :definition #'+lsp-lookup-definition-handler
    :references #'+lsp-lookup-references-handler
    :documentation '(lsp-describe-thing-at-point :async t)
    :implementations '(lsp-find-implementation :async t)
    :type-definition #'lsp-find-type-definition)

  (when (modulep! :ui modeline +light)
    (defvar-local lsp-modeline-icon nil)

    (add-hook! '(lsp-before-initialize-hook
                 lsp-after-initialize-hook
                 lsp-after-uninitialized-functions
                 lsp-before-open-hook
                 lsp-after-open-hook)
      (defun +lsp-update-modeline (&rest _)
        "Update modeline with lsp state."
        (let* ((workspaces (lsp-workspaces))
               (face (if workspaces 'success 'warning))
               (label (if workspaces "LSP Connected" "LSP Disconnected")))
          (setq lsp-modeline-icon (concat
                                   " "
                                   (+modeline-format-icon 'faicon "nf-fa-rocket" "" face label -0.0575)
                                   " "))
          (add-to-list 'global-mode-string
                       '(t (:eval lsp-modeline-icon))
                       'append)))))

  (when (modulep! :completion company)
    (add-hook! 'lsp-completion-mode-hook
      (defun +lsp-init-company-backends-h ()
        (when lsp-completion-mode
          (set (make-local-variable 'company-backends)
               (cons +lsp-company-backends
                     (remove +lsp-company-backends
                             (remq 'company-capf company-backends)))))))))


(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :commands lsp-ui-mode
  :init
  (defadvice! +lsp--use-hook-instead-a (fn &rest args)
    "Change `lsp--auto-configure' to not force `lsp-ui-mode' on us. Using a hook instead is more sensible."
    :around #'lsp--auto-configure
    (letf! ((#'lsp-ui-mode #'ignore))
      (apply fn args)))

  :config
  (set-lookup-handlers! 'lsp-ui-mode
    :definition 'lsp-ui-peek-find-definitions
    :implementations 'lsp-ui-peek-find-implementation
    :references 'lsp-ui-peek-find-references
    :async t)

  (setq lsp-ui-peek-enable t
        lsp-ui-peek-peek-height 20
        lsp-ui-peek-list-width 50
        lsp-ui-peek-show-directory t
        lsp-ui-peek-fontify 'on-demand

        lsp-ui-doc-enable t
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-position 'top
        lsp-ui-doc-side 'right
        lsp-ui-doc-max-height 13
        lsp-ui-doc-max-width 72
        lsp-ui-doc-delay 0.1
        lsp-ui-doc-show-with-mouse nil
        lsp-ui-doc-show-with-cursor t

        lsp-ui-sideline-enable nil
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-actions-icon lsp-ui-sideline-actions-icon-default)

  (map! :map lsp-ui-mode-map
        "C-c m" #'lsp-ui-peek-find-definitions
        "C-c i" #'lsp-ui-peek-find-implementation
        "C-c r" #'lsp-ui-peek-find-references))
