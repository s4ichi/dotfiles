
(ivy-mode 1)
(ivy-rich-mode 1)

(setq ivy-height 17
      ivy-wrap t
      ivy-fixed-height-minibuffer t
      projectile-completion-system 'ivy
      ;; disable magic slash on non-match
      ivy-magic-slash-non-match-action nil
      ;; don't show recent files in switch-buffer
      ivy-use-virtual-buffers nil
      ;; ...but if that ever changes, show their full path
      ivy-virtual-abbreviate 'full
      ;; don't quit minibuffer on delete-error
      ivy-on-del-error-function #'ignore
      ;; enable ability to select prompt (alternative to `ivy-immediate-done')
      ivy-use-selectable-prompt t)
