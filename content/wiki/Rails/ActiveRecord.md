---
title: Active Record
created_at: <2012-12-25 11:45:10>
updated_at: <2013-01-21 12:10:34>
tags: [model, web, rails, ruby]
---

test association loaded:

```ruby
association(name).loaded
```

pluck

```ruby
pluck(:name)

select(:name).all.map(&:name)
```

[sanitize sql](http://stackoverflow.com/a/1723844/667158)

```ruby
sanitize_sql_array(["LEFT JOIN blah AS blah2 ON blah2.title = ?", @blah.title])
```

ease using single table inheritance in url helper

```ruby
def self.inherited(child)
  child.instance_eval do
    def model_name
      Vehicle.model_name
    end
  end
  super
end
```

