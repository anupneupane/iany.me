---
updated_at: <2013-04-25 19:10:57>
created_at: <2011-12-03 03:40:47>
title: Orgmode
tags: emacs, gtd, orgmode
---

Reivew
------

- Set `org-agenda-skip-deadline-if-done` and `org-agenda-skip-scheduled-if-done`
  to `nil` to include finished tasks
- Use `C-u l` or `v L` to include all state changes

Babel
-----

### awk

There are three AWK-specific header arguments.

-   `:cmd-line`: takes command line arguments to pass to the AWK executable 
-   `:in-file`: takes a path to a file of data to be processed by AWK 
-   `:stdin`: takes an Org-mode data or code block reference, the value of
    which will be passed to the AWK process through STDIN

