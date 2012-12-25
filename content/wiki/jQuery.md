---
updated_at: <2012-12-21 13:12:33>
created_at: <2011-12-03 03:40:47>
title: jQuery
tags: javascript, web
---

Ajax Events
-----------

<http://docs.jquery.com/Ajax_Events>

Global events are useful to setup global loading indicator and error notification.

triggerHandler
--------------

The `.triggerHandler()` method behaves similarly to `.trigger()`, with the following exceptions:

-   The `.triggerHandler()` method does not cause the default behavior of an
    event to occur (such as a form submission).
-   While `.trigger()` will operate on all elements matched by the jQuery
    object, `.triggerHandler()` only affects the first matched element.
-   Events created with `.triggerHandler()` do not bubble up the DOM hierarchy;
    if they are not handled by the target element directly, they do nothing.
-   Instead of returning the jQuery object (to allow chaining),
    `.triggerHandler()` returns whatever value was returned by the last
    handler it caused to be executed. If no handlers are triggered, it returns
    undefined

Toolkits
--------

- object to `x-www-form-urlencoded`: `$.param`

