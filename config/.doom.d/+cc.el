;; FIXME: Overwrite rtags integrations
(set-lookup-handlers! '(c-mode c++-mode)
  :definition #'projectile-find-tag
  :references #'projectile-find-tag)
