---
updated_at: <2013-01-29 23:19:57>
created_at: <2013-01-29 22:23:28>
title: Rails JavaScript test with Jasmine Gem
tags: [rails, javascript, test]
tmpl: hb
---

> [Jasmine][] is a behavior-driven development framework for testing JavaScript
> code. It does not depend on any other JavaScript frameworks. It does not
> require a DOM. And it has a clean, obvious syntax so that you can easily write
> tests.

It is very easy to integrate Jasmine into Rails, since the team provides the
[jasmine gem][]. But, with the default configuration, the specs must be
writting in JavaScript.

There are some solutions for writing specs using CoffeeScript:

-   [jasminerice][]: It is mounted into Rails, so the CoffeeScript compilation
    can be delegated to asset pipeline.
-   [jasmine-headless-webkit][]: It uses Qt Webkit to run specs.

But, indeed, with some tricks, jasmine gem itself can run specs written in
CoffeeScript. So the CI environment can uses `rake jasmine:ci` directly.

{{more}}

Jasmine Integration
-------------------

Jasmine gem allows adding assets files as src by prepending the path
`assets/`. Since all the sources and specs are added in test page in sequence,
the CoffeeScript specs can be added as `src_files`.

-   First add `jasmine` in Gemfile
    
    ```ruby
    group :development, :test do
      gem "jasmine"
    end
    ```

    and run `bundle install`.

-   Then generate config:

        rails g jasmine:install

-   Append `spec/javascripts` to assets path. Create file
    `spec/javascripts/support/jasmine_config.rb`, and add following line to
    the file:
    
        Rails.application.assets.append_path File.expand_path('../..', __FILE__)

-   Edit `spec/javascripts/support/jasmine.yml`. Append `assets/specs.js` to
    `src_files`, and set spec_files to `[]` (otherwise specs written in
    JavaScript will be executed twice).

-   Create the file `spec/javascripts/specs.js`. Usually, it just needs to
    include all the js files in directory `spec/javascripts`:
    
        //= require_tree ./

-   Create a spec file to test the integration, e.g.,
    `spec/javascripts/foobar_spec.js.coffee`
    
        ```
        # spec/javascripts/foobar_spec.js.coffee
        describe "foobar", ->
          it 'works', -> expect(1 + 1).toEqual(2);
        ```

-    Start jasmine server by `rake jasmine` and visit the test page
     `http://localhost:8888`.

Guard
---------



CI
---------


References
----------

- [jasmine gem][]
- [bradphelan/jasminerice][jasminerice]
- [#261 Testing JavaScript with Jasmine - RailsCasts][RailsCasts #261]
- [#261 Testing JavaScript with Jasmine (revised) - RailsCasts][RailsCasts #261 revised]

[jasmine]: http://pivotal.github.com/jasmine/
[jasmine gem]: https://github.com/pivotal/jasmine-gem "jasmine-gem"
[jasminerice]: https://github.com/bradphelan/jasminerice "bradphelan/jasminerice"
[jasmine-headless-webkit]: http://johnbintz.github.com/jasmine-headless-webkit/
[railscasts #261]: http://railscasts.com/episodes/261-testing-javascript-with-jasmine "#261 Testing JavaScript with Jasmine - RailsCasts"
[railscasts #261 revised]: http://railscasts.com/episodes/261-testing-javascript-with-jasmine-revised "#261 Testing JavaScript with Jasmine (revised) - RailsCasts"

