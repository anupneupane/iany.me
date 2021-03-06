---
updated_at: <2012-12-11 18:37:48>
title: Fix TAB Binding For yasnippet And auto-complete
tags: [emacs]
tmpl: hb
---

There are two TAB's in Emacs, `(kbd "TAB")` (`\t`, `[9]`) and `(kbd "<tab>")`
(`[tab]`). If modes like [yasnippet][] and [auto-complete][] want to bind on
`TAB`, their trigger key must be the same with the original Tab command. Since
Emacs binds `indent-for-tab-command` on `(kbd "TAB")`, so it's better to use
it as the trigger key. Yasnippet binds to it by default, It is also easy to
setup `auto-complete` to trigger using Tab.

```cl
;; trigger using TAB and disable auto start
(custom-set-variables
 '(ac-trigger-key "TAB")
 '(ac-auto-start nil)
 '(ac-use-menu-map t))
```

But in some modes (`ruby-mode`, `markdown-mode`, `org-mode`), the command is
bind to `(kbd "<tab>")`, when the real Tab key is typed, the function bind on
`(kbd "<tab>)` has higher priority, so yasnippet and auto-complete are not
invoked. It is easy to fix by moving the keybinding:

```cl
(defun iy-tab-noconflict ()
  (let ((command (key-binding [tab]))) ; remember command
    (local-unset-key [tab]) ; unset from (kbd "<tab>")
    (local-set-key (kbd "TAB") command))) ; bind to (kbd "TAB")
(add-hook 'ruby-mode-hook 'iy-ac-tab-noconflict)
(add-hook 'markdown-mode-hook 'iy-ac-tab-noconflict)
(add-hook 'org-mode-hook 'iy-ac-tab-noconflict)
```

[yasnippet]: http://capitaomorte.github.com/yasnippet/index.html
[auto-complete]: https://github.com/m2ym/auto-complete
