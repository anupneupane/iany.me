---
updated_at: <2012-12-25 11:42:00>
created_at: <2012-12-25 11:41:35>
title: Handlebars
tags: [template]
---

Handlebars.rb
-------------

-   helper method arguments:

        def gist(this, gist, options, block)
        end

    -   this: function context
    -   gist: first argument
    -   options: named arguments are passed as options['hash']
    -   block: block content are passed as `V8::Function`
    
    String must be double-quoted

        {{gist("1234223" file="test.txt")}}

