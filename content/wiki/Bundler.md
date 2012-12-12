---
updated_at: <2012-01-23 19:19:52>
created_at: <2011-12-03 03:41:28>
title: Bundler
tags: ruby, gem
---

## Gem Version ##

See <http://docs.rubygems.org/read/chapter/16>

    =  Equals version
    != Not equal to version
    >  Greater than version
    <  Less than version
    >= Greater than or equal to
    <= Less than or equal to
    ~> Approximately greater than
       ~> 2.2  [2.2, 3.0)
       ~> 2.2.0  [2.2.0, 2.3.0)

## Options ##

- `require`: file to be required
- `git`: git repository to get the gem, also see `ref`, `branch`, `tag`.
- `path`: install gem from local directory

## Git Source ##

If a git repository contains multiple gemspec, the git can be added as a source:

    git 'git://github.com/rails/rails.git'
