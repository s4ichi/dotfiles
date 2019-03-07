(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-jsx-mode))
(add-to-list 'auto-mode-alist '("\\.es6\\'" . js2-mode))
(flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)
(add-hook 'js2-jsx-mode-hook 'flycheck-mode)
