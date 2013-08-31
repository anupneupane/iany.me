---
updated_at: <2013-08-31 21:46:49>
created_at: <2011-12-03 03:41:28>
title: tmux
tags: [ "linux", "command line" ]
---

## Mac Clipboard Integration

Install `reattach-to-user-namespace`.

    $ brew install reattach-to-user-namespace --wrap-pbcopy-and-pbpaste

Add followings lines in tmux.conf.

    set-option -g default-command "reattach-to-user-namespace -l zsh"
    # Setup 'v' to begin selection as in Vim
    bind-key -t vi-copy v begin-selection
    bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

> - [How to Copy and Paste with Tmux on Mac OS X](http://robots.thoughtbot.com/post/19398560514/how-to-copy-and-paste-with-tmux-on-mac-os-x)
> - [Tmux Copy & Paste on OS X: A Better Future](http://robots.thoughtbot.com/post/55885045171/tmux-copy-paste-on-os-x-a-better-future)
