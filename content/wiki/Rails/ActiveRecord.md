---
title: Active Record
created_at: <2012-12-25 11:45:10>
updated_at: <2013-02-21 22:42:32>
tags: [model, web, rails, ruby]
---

Association
-----------

### test association loaded

```ruby
association(name).loaded
```

### association extension

[ActiveRecord::Associations::ClassMethods](http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html)

```ruby
class User
  has_many :items do
    def extension_method
    end
  end
  
  has_many :items, :extend => MessagesExtension
  module MesagesExtension
    def extension_method
    end
  end
end
```

Some extensions can only be made to work with knowledge of the association’s
internals. Extensions can access relevant state using the following methods
(where items is the name of the association):

-   `record.association(:items).owner` - `user`
    part of.
-   `record.association(:items).reflection` Returns the reflection object that
    describes the association.
-   `record.association(:items).target` - `items`

However, inside the actual extension code, you will not have access to the
record as above. In this case, you can access `proxy_association`. For example,
`record.association(:items)` and `record.items.proxy_association` will return the
same object.

Helper Methods
--------------

pluck

```ruby
pluck(:name)

select(:name).all.map(&:name)
```

[sanitize sql](http://stackoverflow.com/a/1723844/667158)

```ruby
sanitize_sql_array(["LEFT JOIN blah AS blah2 ON blah2.title = ?", @blah.title])
```

Single Table Inheritance
------------------------

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
