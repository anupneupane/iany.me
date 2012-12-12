---
updated_at: <2011-12-08 06:21:43>
created_at: <2011-12-03 03:40:47>
title: Rails Tips
tags: web, rails, ruby
---

Core
----

### Nested Attributes ###

Nested attributes allow you to save attributes on associated records through the
parent. By default nested attribute updating is turned off, you can enable it
using the `accepts_nested_attributes_for` class method. When you enable nested
attributes an attribute writer is defined on the model.

See [NestedAttributes ClassMethods](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html)

Enable mass assignment (though `fields_for`). Add `attr_accessible:#{child_class}_attributes`

### HashWithIndifferentAccess ###

String key and symbol key get same value.

See [HashWithIndifferentAccess](http://as.rubyonrails.org/classes/HashWithIndifferentAccess.html)
