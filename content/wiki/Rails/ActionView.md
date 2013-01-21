---
title: Action View
created_at: <2012-12-25 11:43:46>
updated_at: <2013-01-21 12:47:35>
tags: [web, rails, ruby, view]
---

Render
------

- `:object` pass as variable name same with template file name
- `:as` change object variable name in template file


Partial Path
------------

```ruby
class Event < ActiveRecord::Base
  # ...
  def to_partial_path
    "events/#{trigger}"  # events/edit or events/view
  end
end
```

```rhtml
  <%= render partial: @events, as: :event %>
```
