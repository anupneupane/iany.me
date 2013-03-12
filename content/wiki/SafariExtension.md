---
title: Safari Extension
created_at: <2013-02-26 17:49:19>
updated_at: <2013-03-12 23:15:41>
tags: [browser, extension]
---

## Sign Up as a Safari Developer ##

-   Sign up [Safari Program](http://developer.apple.com/programs/safari/)
-   Then go to the [Safari Extension Certificate Utility](http://developer.apple.com/certificates/safari/)

## Extension Builder ##

Open Safari, go to the Advanced tab in Safari Preferences and check the box
next to "Show Develop in the menu bar". The Develop menu should now appear,
just select "Show Extension Builder".

## JavaScript Injection ##

Add js files as **Start Scripts** in extension builder.

The injected scripts cannot send AJAX requests to other domains.

> ... do the cross-domain ajax via the background page. ... message pass the
> requests to the background page. The background page listens for messages
> from the injected script, makes the appropriate ajax calls, and then sends
> the results via a message to the injected script. The injected script is
> then listening for messages from the background page, once it gets the
> message(s) with the ajax results, it takes the appropriate action in the
> page that's being viewed.
> <small>[Cross origin AJAX call in Safari extension injected script - Stack Overflow][safari cors]</small>

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

Add background page html file as Global Page in extension builder. Include
following background script in the background page.

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

## IFrame Injection ##

HTML files in extension can be inserted into page as `iframe`. The URL is:

    safari.extension.baseURI + path

The JavaScript code in iframe cannot access the page directly, must `dispatchMessage` to
injected scripts. However the message sent from iframe are handled by
background scripts, so background scripts must forward the message to injected
scripts.

Following example demonstrates how to close iframe in iframe itself.

In iframe script:

```javascript
var close = function() {
  safari.self.tab.dispatchMessage('closeNotification', {});
};
```

Forward message in background script:

```javascript
var onMessage = function(event) {
  if (event.name === 'closeNotification') {
    event.target.page.dispatchMessage('closeNotification', event.message);
  }
};

safari.application.addEventListener("message", onMessage, false);
```

Handle the message In injected script:

```javascript
var onMessage = function(event) {
  if (event.name === 'closeNotification') {
    $('#notification').hide();
  }
};

safari.self.addEventListener('message', onMessage, false);
```

## References ##

-   [How to Create a Safari Extension from Scratch](http://net.tutsplus.com/tutorials/other/how-to-create-a-safari-extension-from-scratch/)

[safari cors]: http://stackoverflow.com/questions/8444324/cross-origin-ajax-call-in-safari-extension-injected-script

