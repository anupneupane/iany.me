---
updated_at: <2012-12-19 01:49:31>
created_at: <2012-12-19 01:44:00>
title: FactoryGirl
tags: [ruby, test]
---

[GETTING_STARTED](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md)

accessible attributes

```ruby
def FactoryGirl.accessible_attributes_for(*args)
  object = self.build(*args)
  object.attributes.slice(*object.class.accessible_attributes).symbolize_keys
end
```

paperclip attribute

```ruby
# spec/spec_helper.rb
include ActionDispatch::TestProcess

# factories/posts.rb
factory :post do
  attachment {
    file = Rails.root.join('public/sample/sample.pdf')
    type = 'application/pdf'
    fixture_file_upload(file, type)
  }
end
```
