---
updated_at: <2013-05-11 22:56:27>
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

### Strip invalid chars ###

```ruby
str.encode("UTF-16BE", :undef => :replace, :invalid => :replace, :replace => "")
  .encode("UTF-8")
  .gsub("\0".encode("UTF-8"), "")

# 2.1 way
str.scrub("")
```
