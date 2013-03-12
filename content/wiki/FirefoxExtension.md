---
title: Firefox Extension
created_at: <2013-02-26 17:49:19>
updated_at: <2013-03-12 22:26:34>
tags: [browser, extension]
---

chrome.manifest
---------------

Resources in Firefox extension should be added as Chrome Manifest package.

    content sample chrome/content
    
Where `sample` is the package name, `chrome/content` is the directory
path. Then the file `chrome/content/sample.xul` can be accessed through
`chrome://sample/content/sample.xul`. For example:

    overlay chrome://browser/content/browser.xul chrome://sample/content/sample.xul 

JavaScript Injection
--------------------

Declare overlay in `chrome.manifest`:

```
content sample chrome/content/;
overlay chrome://browser/content/browser.xul chrome://sample/content/sample.xul 
overlay chrome://messenger/content/messenger.xul chrome://sample/content/sample.xul 
overlay chrome://songbird/content/xul/layoutWithBrowserOverlay.xul chrome://sample/content/sample.xul
overlay chrome://navigator/content/navigator.xul chrome://sample/content/sample.xul 
overlay chrome://midbrowser/content/midbrowser.xul chrome://sample/content/sample.xul
overlay chrome://emusic/content/startup.xul  chrome://sample/content/sample.xul
```

And include scripts in `sample.xul`

```
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE overlay>

<overlay xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" id="sample">
  <script type="application/x-javascript" src="chrome://sample/content/inject.js" />
</overlay>
```

The inject JavaScript has no cors limit on AJAX requests, but cannot insert
iframe linking to extension resources.

IFrame injection
----------------

Firefox injected scripts cannot insert iframe pointing to resources in
extension. Create a UI component (such as sidebar) though `xul` instead.

Simple notification can use
[NotificationBox API](https://developer.mozilla.org/en-US/docs/XUL/notificationbox).

References
----------

-   [Building an extension | MDN](https://developer.mozilla.org/en-US/docs/Building_an_Extension)
-   [Chrome registration | MDN](https://developer.mozilla.org/en-US/docs/Chrome_Registration)
