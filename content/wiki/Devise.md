---
updated_at: <2012-02-04 19:42:24>
created_at: <2011-12-03 03:40:47>
title: Devise
tags: [rails, authentication, ruby, gem]
---

[Devise Github Page](https://github.com/plataformatec/devise)

Test
----

Refer to this [Tutorial](https://github.com/RailsApps/rails3-devise-rspec-cucumber/wiki/Tutorial)

### Confirmation mail error ###

Add following lines in `config/environments/test.rb`

    config.action_mailer.default_url_options = { :host => 'localhost:3000' }

### Helpers ###

    RSpec.configure do |config|
      config.include Devise::TestHelpers, :type => :controller
    end
