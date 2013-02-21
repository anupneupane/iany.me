---
updated_at: <2013-02-21 23:08:47>
created_at: <2011-12-03 03:40:47>
title: Nested Model Form
tags: [rails, ruby, web, form]
---

accepts\_nested\_attributes\_for
--------------------------------

Nested attributes allow you to save attributes on associated records through the
parent. By default nested attribute updating is turned off, you can enable it
using the `accepts_nested_attributes_for` class method. When you enable nested
attributes an attribute writer is defined on the model.

See [NestedAttributes ClassMethods](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html)

-   Enable mass assignment (though `fields_for`). Add `attr_accessible :#{child_class}_attributes`

-   Remove nested model: Enable `:destroy => true`, and add field `_destory`
    in form.


fields\_for
-----------

Add associations into the form.

If the model has nested attributes writer `#{name}_attributes=`, builder
inside `fields_for` will use the attribute name
`#{name}_attributes`. Otherwise just use attribute name `#{name}`.

If `id` field is not inserted, form builder will insert it after block in
`fields_for`. So `id` field must be specified explicitly when list fields in
list or table.

`fields_for` is usually used to embed associations in
form. However,

> all it required was a method to return the named attribute, and then a
> `<field>_attributes=` writer to interpret the hash on the other side.
> <small>[Compound Attributes and fields_for in Rails | Wondible](http://wondible.com/2011/06/11/compound-attributes-and-fields_for-in-rails/)</small>

`fields_for` also can be used to manually iterate associated collection:

```rhtml
<%= f.fields_for :items, item1 do %>
  ...
<% end %>
...
<%= f.fields_for :items, item2 do %>
  ...
<% end %>
```

Add fields dynamically
----------------------

[Helper and js handler](http://bitly.com/bundles/iany/5) for add/remove links.

`link_to_add_fields` uses partial to generate template for new
field. JavaScript use timestamp as unique ID.

```ruby
def link_to_add_fields(name, f, association, new_object = nil)
  new_object ||= f.object.send(association).klass.new
  id = new_object.object_id
  fields = f.fields_for(association, new_object, child_index: id) do |builder|
    render(association.to_s.singularize + "_fields", f: builder)
  end
  link_to(name, '#', class: "add-fields", data: {id: id, fields: fields.gsub("\n", "")})
end
```

```javascript
body.on('click', '.remove-fields', function(e) {
  e.preventDefault();
  console.log($(e.target));
  console.log($(e.target).closest('.field-container'));
  $(e.target).closest('.field-container').remove();
});

var fieldId = 0;

body.on('click', '.add-fields', function(e) {
  var $target = $(e.target);
  var id = $target.attr('data-id');
  var fields = $target.attr('data-fields');
  var timestamp = new Date().getTime() * 10 + (fieldId % 10);
  fieldId = fieldId + 1;
  var regexp = new RegExp(id, 'g');
  $target.closest('.field-container').before(fields.replace(regexp, timestamp));
});
```

Append new fields
-----------------

```ruby
def show
  @user = User.find(params[:id])
  @addresses = @user.addresses.to_a + [ Address.new ]
end
```

```rhtml
<%= fields_for :addresses, @addresses %>
  ...
<% end %>
```
