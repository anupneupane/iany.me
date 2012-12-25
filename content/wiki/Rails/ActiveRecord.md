---
title: Active Record
created_at: <2012-12-25 11:45:10>
updated_at: <2012-12-25 11:45:45>
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

