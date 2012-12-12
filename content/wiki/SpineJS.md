---
title: SpineJS
created_at: <2012-02-04 19:42:57>
updated_at: <2012-12-12 07:07:07>
tags: javascript, mvc
---

Class/Module
------------

### Methods

- `@extend(Module)`: add properties to Class, then execute `extended` method
  in the Class context.
  
- `@include(Module)`: add properties to Class prototype, then execute
  `included` method in the Class context.

### Howto In Javascript ###

-   Inheritance

    ```javascript
    Spine.Class.sub(instances, statics);
    # Spine.Class.sub().include(instances).extend(statics);
    ```

-   Construct and call super

    ```javascript
    Spine.Class.sub({
      init: function () {
        this.constructor.__super__.init.apply(this, arguments)
      }
    });
    ```

Model
-----

-   Inherit from `Spine.Model`

-   `Spine.Model.configure(modelName, attributes...)` to bootstrap the model class.

-   `Spine.Model::save` save to memory and generate a unique `id` for new record. It is **duplicated** and saved into `::records`.

-   `Spine.Model.find(id)` to retrieve. It is fetched from `::records` and **duplicated**.

-   Iterator use `all`, `each`, `select` (like `find_all` in ruby).

-   `validate` returns error message to indicate validation error. Validation error triggers `error` event.

-   `JSON.stringify(Contact)` to serialize all contacts to JSON. `JSON.stringify(Contact.first)` to serialize one.

### Events ###

-   **save**, **beforeSave**: record was saved (either created/updated)
-   **update**, **beforeUpdate**: record was updated
-   **create**, **beforeCreate**: record was created
-   **destroy**, **beforeDestroy**: record was destroyed
-   **change**: any of the above, record was created/updated/destroyed
-   **refresh**: all records invalidated and replaced
-   **error**: validation failed

Events are triggied on constructor (`Spine.Model`) instead. Instance level
bind is also bind on construct, but callback is invoked only when the model
triggering the vent `eql` to current instance.

Multple events can be bind by seperating with space:

    Tasks.bind 'create update destroy', -> @trigger('change')

Bind on `Spine` for global events.

### Sync ###

All clones are updated once the model is saved since attributes are
shared. Events are also shared because `@eql` compares by `id`. And instance
level `bind` calls callback when model type and id match.

Controller
----------

-   Inherit from `Spine.Controller`

-   The object passed to constructor are all set as new created controller
    instance's properties (on the contrast, Backbone set them in @options).

-   Controller is similar to `Backbone.View`. Tag name can be set using `tag`
    property, default is "div". Class can be set using `className`.
    
    ```coffeescript
    class Tasks extends Spine.Controller
      tag: 'div'
      className: 'tasks'
    ```

    Or specified through `el` in constructor.

    The `el` is a wrapped jQuery object, not the native DOM object.

-   `@html` replace inner HTML of `el`
-   `@append` a controller will add append that controller's `el`.

### Events ###

Like `Backbone`, use `events` property.

```coffeescript
class Tasks extends Spine.Controller
  events:
    # eventName selector: function
    'click .action-destroy': 'destroy'
  destroy: (event) ->
    # invoke when .action-destroy is clicked in this object context
```

It is also able to bind events on Controller.

### Elements ###

DOM elements can be cached through `elements` property

```coffeescript
class Tasks extends Spine.Controller
  elements:
    # selector: propertyName
    '.items': '$items'

  constructor: ->
    super
    @$items.each -> #...
```

Call `refreshElements` if the inner HTML is rendered after creating the
controller.

View
----

View is HTML fragment in `Spine`.

[Mustache](http://mustache.github.com/),
[jQuery.tmpl](http://api.jquery.com/category/plugins/templates) or
[Eco](https://github.com/sstephenson/eco).

### Eco ###

Use `require` to load Eco template. (how about `JST[path]`? should also work).

### JEco ###

The redered Eco string is wrapped in jQuery. And the render context object is
attached as data "item". The data "item" can be retrieved using shortcut
`item()` if `spine/lib/tmpl` is loaded. If an array is passed, the template is
iterated to render all elements.

It may be implemented based on `Eco`:

```coffeescript
ecoTemplate = require('views/contacts')
jEcoTemplate = (contextOrArray) ->
  result = $()

  for context in (if Spine.isArray(contextOrArray) then contextOrArray else [contextOrArray])
    result = result.add($(ecoTemplate(context)).data('item', context))

  return result
```

### Helper ###

Convention:

-   Add helper method in property `helper`.
-   Pass controller instance as template context.

Routing
-------

-   Include `route.coffee`. `Spine.Route` adds `routes` method to `Spine.Controller`.
-   Or use `Spine.Route.add` method to add route rules.
-   The most specific routes should be added first. Catch all route rules should be added last.
-   Use `Spine.Route.setup()` to detect current hashtag after page load, and trigger callbacks.
-   `Spine.Route` gives controller `navigate` method. Or use
    `Spine.Route.navigate`. If last argument is `true`, the callbackes are
    triggered.
-   `@navigate('/users', @item.id)` navigates to `/usrs/:id`
-   `Spine.Route.setup(history: true)` to support HTML5 history.
-   `Spine.Route.setup(shim: true)` use routing without changing page's URL.

Stack
-----

-   include `stacks`
-   Add controllers using `Stack.controllers`.
-   All controllers' `el` are appended to Stack's `el`.
-   `active` method add `active` class to that controller's `el` and remove it
    from other controllers.
-   Use `default` to setup default controller.

Stack also have a `routes` method to setup routing.

```coffeescript
  routes:
    # url: controllerOrCallback
    '/posts/:id/edit': 'edit'
    '/posts/:id':      'show'
```

The controller is active when a URL matches.

Form/Validation
---------------

-   `Model.fromForm` and `Model::fromFrom`.

Persistence
-----------

### Local Storgae ###

-   extend `Spine.Model.Local`
-   Fetch records from local: `Contact.fetch()`
-   `fetch()` triggers `refresh` event.

### AJAX ###

-   extend `Spine.Model.Ajax`
-   customize URL though `Model.url` property. `Model::url()` can be used to
    generate a URL relative to `Model.url`.
-   customize API server th `Spine.Model.host`.
-   `fetch()` to load and triggers `refresh` event.
-   `fetch(param)`, param are sent to server as parameters.
-   customize serialization by overriding `fromJSON()` and `toJSON()`. They
    should be customized prior to Rails 3.1 because of the name prefix in
    JSON. Since Rails 3.1, set `ActiveRecord::Base.include_root_in_json` in
    `config/initializers/wrap_parameters.rb`.
-   Temporarily disable AJAX using `Spine.Ajax.disable -> record.destroy()`.
    Or disable automatical AJAX calls by extending
    `Spine.Model.Ajax.Methods`.

#### Events

```coffeescript
Contact.bind "ajaxError", (record, xhr, settings, error) -> 
  # Invalid response...
Contact.bind "ajaxSuccess", (status, xhr) -> 
  # Invalid response...
```

#### AJAX Queue

Requests are sent out serially.

To append new request to the queue:

```coffeescript
Spine.Ajax.queue ->
  $.post('/posts/custom')
```

Changes may be lost if use leaves the page. Listen event `onbeforeunload` and
check `Spine.Ajax.pending` in it.

Useful Methods
--------------

-   `Spine.isArray`
