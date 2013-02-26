---
updated_at: <2013-02-26 17:48:23>
created_at: <2011-12-03 03:41:28>
title: Javascript
tags: javascript
---

## Tips ##

- `sort` is not stable.
- Get formal arguments names: `arguments.callee.caller.toString()`

## Regexp ##

### regexp.exec ###

If the regexp has `g` modifier, `regexp.exec` search starting at
`regexp.lastIndex`. To search again after breaking a search, must 
reset it manually to 0.

