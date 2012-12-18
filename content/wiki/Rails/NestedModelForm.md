---
updated_at: <2012-12-19 01:54:04>
created_at: <2011-12-03 03:40:47>
title: Nested Model Form
tags: [rails, ruby, web, form]
---

Nested attributes allow you to save attributes on associated records through the
parent. By default nested attribute updating is turned off, you can enable it
using the `accepts_nested_attributes_for` class method. When you enable nested
attributes an attribute writer is defined on the model.

See [NestedAttributes ClassMethods](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html)

Enable mass assignment (though `fields_for`). Add `attr_accessible :#{child_class}_attributes`

Remove nested model: Enable `:destroy => true`, and add field `_destory` in
form.

[Helper and js handler](http://bitly.com/bundles/iany/5) for add/remove links.

If `id` field is not inserted, form builder will insert it after block in
`fields_for`. So `id` field must be specified explicitly when list fields in
list or table.


