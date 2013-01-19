MathJax.Hub.Config
  config: ["MMLorHTML.js"]
  jax: ["input/TeX", "output/HTML-CSS"]
  extensions: ["tex2jax.js","MathMenu.js","MathZoom.js"],
  elements: ['main']
  errorSettings:
    message: ["[Math Error]"]
  TeX:
    extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"]
  tex2jax:
    inlineMath: [ ['\\(','\\)'] ]
    displayMath: [ ['\\[','\\]'] ]
    skipTags: ["script","noscript","style","textarea","pre","header","nav"]
    preview: [["i",{class: "icon-spin"}]]

MathJax.Ajax.loadComplete("[MathJax]/config/ianyme.js")
