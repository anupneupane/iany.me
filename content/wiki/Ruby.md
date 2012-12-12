---
updated_at: <2012-01-23 22:41:00>
created_at: <2011-12-03 03:40:47>
title: Ruby
tags: ruby
---

Tips
-------

### File Path ###

-   Get file in current directory

        File.expand_path('../file', __FILE__)
        File.join(File.dirname(File.expand_path(__FILE__)), 'file')

### split ###

If split regexp contains capture group, all groups are returned in sequence:

    "axyb".split(/((x)(y))/)
    # => ['a', 'xy', 'x', 'y', 'b']

### Inline Test ###

    if __FILE__ == $PROGRAM_NAME
      ...

### break ###

    break statement #= statement; break
