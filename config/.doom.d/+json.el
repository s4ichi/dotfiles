(add-hook! 'json-mode-hook
  (lambda ()
    (make-local-variable 'js-indent-level)
    (setq tab-width 2)
    (setq js-indent-level 2)))
