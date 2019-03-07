;; need packages
;; go get github.com/kisielk/errcheck
;; go get github.com/rogpeppe/godef
;; go get github.com/golang/lint/golint
;; go get -u github.com/nsf/gocode

(defun go-mode-setup ()
  (setq c-basic-offset 4)
  (setq indent-tabs-mode t)
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  (local-set-key (kbd "C-c d") 'godoc)
  (add-hook 'before-save-hook 'gofmt-before-save))

(add-hook 'go-mode-hook 'go-mode-setup)
