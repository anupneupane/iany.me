---
updated_at: <2011-12-08 06:30:56>
created_at: <2011-12-03 03:40:47>
title: RSpec
tags: ruby, test
---

Mock Helper
-----------

Include `ActionView::Helpers` and mock on `self`. See
[how to mocking out your rails helpers in helper specs](http://openmonkey.com/2008/03/19/mocking-out-your-rails-helpers-in-helper-specs)

Rails with Capypara
-------------------

```ruby
group :test, :development do
  gem 'rspec-rails'
end
group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
end
```

```ruby
# spec/spec_helper.rb
require 'capybara/rspec'
````

Capypara handles its own session, use `page.driver` to send requests:

    page.driver.post session_path, :session => credentials
