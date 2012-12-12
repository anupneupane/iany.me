---
updated_at: <2011-12-08 06:29:35>
created_at: <2011-12-03 03:40:47>
title: Rails Config
tags: web, rails, ruby
---

application.rb
--------------

### rails components

```ruby
# require 'rails/all'
require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'rails/test_unit'
# default ends here

# followings are loaded as dependencies
require 'active_model/railtie'
require 'active_view/railtie'
```

### load

Auto load paths:

    config.autoload_paths += %W{#{config.root}/extras}
    
Plugin load sequence

    config.plugins = [:first_plugin, :all]

### generators

    config.generators do |g|
      g.stylesheet_engine :sass
      g.template_engine :haml
      g.test_framework :rspec, :fixture => false
    end

initializers
------------

- `backtrace_silencers`: remove useless info from backtrace
- `secret_token`: sign cookie
- `inflections`
- `mime_type`
- `session_store`

threadsafe
----------

Useful for JRuby.

    config.threadsafe!

It conflicts with development mode.
    