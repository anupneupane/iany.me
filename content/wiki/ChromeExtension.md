---
title: Chrome Extension
created_at: <2013-02-26 17:52:21>
updated_at: <2013-03-12 23:17:37>
tags: [browser, extension]
---

JavaScript Injection
--------------------

Add files in
[`manifest.json`](http://developer.chrome.com/extensions/manifest.html) as
`content_scripts.js`:

```javascript
{
  "content_scripts": [ {
    "js": [ "inject.js " ]
  } ]
}
```

Content scripts cannot use most chrome extension API, forward to background
scripts using `sendMessage`:

```javascript
chrome.extension.sendMessage({
  message:'openOrSwitchTo',
  url:'http://iany.me'
}, function() {})
```

Add background page in `manifest.json`:

```javascript
  ...
  "background": {
    "page": "background.html"
  },
  ...
```

Then include following background script in `background.html` to handle the message:

```javascript
chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
  if (request && request.message === 'openOrSwitchTo') {
    chrome.tabs.query({url: request.url + '*'}, function (tabs) {
      if (tabs.length > 0) {
        chrome.tabs.update(tabs[0].id, {active: true, highlighted: true});
      } else {
        chrome.tabs.create({url: request.url, active: true});
      }
    });
  }
});
```

## IFrame Injection ##

HTML files in extension can be inserted into page as `iframe`. The URL is:

    chrome.extension.getURL(path);

The JavaScript code in iframe cannot access the page directly, must `sendMessage` to
content scripts. However the message sent from iframe are handled by
background scripts, so background scripts must forward the message to content
scripts.

Following example demonstrates how to close iframe in iframe itself.

In iframe script:

```javascript
var close = function() {
  chrome.extension.sendMessage({message:'closeNotification'}, function () {});
};
```

Forward message in background script:

```javascript
chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
  if (request && request.message === 'closeNotification') {
    chrome.tabs.sendMessage(sender.tab.id, request, sendResponse);
  }
});
```

Handle the message In content script:

```javascript
chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
  if (request && request.message === 'closeNotification') {
    $('#notification').hide();
  }
});
```

References
----------

-   [Manifest Files](http://developer.chrome.com/extensions/manifest.html)
-   [Message Passing](https://developer.chrome.com/extensions/messaging.html)
