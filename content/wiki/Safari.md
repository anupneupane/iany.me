---
title: Safari
created_at: <2013-02-26 17:49:19>
updated_at: <2013-03-12 21:42:56>
tags: [browser, extension]
---

Extension
---------

### Sign Up as a Safari Developer ###

-   Sign up [Safari Program](http://developer.apple.com/programs/safari/)
-   Then go to the [Safari Extension Certificate Utility](http://developer.apple.com/certificates/safari/)

### Extension Builder ###

Open Safari, go to the Advanced tab in Safari Preferences and check the box
next to "Show Develop in the menu bar". The Develop menu should now appear,
just select "Show Extension Builder".

### JavaScript Inject ###

Add start scripts in extension builder.

The injected scripts cannot send AJAX requests to other domains.

> ... do the cross-domain ajax via the background page. ... message pass the
> requests to the background page. The background page listens for messages
> from the injected script, makes the appropriate ajax calls, and then sends
> the results via a message to the injected script. The injected script is
> then listening for messages from the background page, once it gets the
> message(s) with the ajax results, it takes the appropriate action in the
> page that's being viewed.
> <small>[Cross origin AJAX call in Safari extension injected script - Stack Overflow][0]</small>

[0]: http://stackoverflow.com/questions/8444324/cross-origin-ajax-call-in-safari-extension-injected-script

Example:

In injected script:

```javascript
var onResponse = function(event) {
  if (event.name === 'getJSONResponse') {
    console.log(event.message);
  }
};
safari.self.addEventListener('message', onResponse, false);

var getJSON(url) {
  safari.self.tab.dispatchMessage('getJSONRequest', url);
};

getJSON('events.json');
```

Add background page html file as Global Page in extension builder. Add
background scripts in the background page.

```javascript
var onRequest = function(event) {
  if (event.name == 'getJSONRequest') {
    $.getJSON(event.message).done(function(data) {
      event.target.page.dispatchMessage('getJSONResponse', data);
    });
  }
};
safari.application.addEventListener("message", onRequest, false);
```

References
----------

-   [How to Create a Safari Extension from Scratch](http://net.tutsplus.com/tutorials/other/how-to-create-a-safari-extension-from-scratch/)
