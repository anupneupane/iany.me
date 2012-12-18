---
updated_at: <2012-12-19 01:33:52>
created_at: <2011-12-03 03:40:47>
title: RSpec
tags: [ruby, test]
---

Rails
-----

### Helper ###

Include `ActionView::Helpers` and mock on `self` [^1].

### Acceptance with Capybara ###


-   spec_helper.rb

        require 'capybara/rspec'

-   put specs in spec/features, or tag example `:type => :feature`
-   enable js by `:js => true`
-   capybara cannot access request nor session object.

Matchers
--------

-   [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
-   [rspec-html-matchers](https://github.com/kucaahbe/rspec-html-matchers)

[^1]: [how to mocking out your rails helpers in helper specs](http://openmonkey.com/2008/03/19/mocking-out-your-rails-helpers-in-helper-specs)
