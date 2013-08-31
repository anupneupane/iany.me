---
created_at: <2012-03-30>
updated_at: <2013-09-01 02:01:07>
title: Use Popup isearch For Yasnippet Prompt
tags: [emacs]
tmpl: hb
---

[Yasnippet][] tries functions in `yas/prompt-functions` when it needs user to
select one choice, such as selecting snippets with the same trigger key, such
as helper method `yas/choose-value`.

[popup][] is a visual popup interface library extracted from [auto-complete][]
by its author. It has better look and feel than all the built-in
`yas/prompt-functions`. Also it is easy to customize, and its isearch mode is
very efficient, the items are filtered on-the-fly when typing.

{{#thumbnails "row"}}
  {{#thumbnail "col-sm-6"}}
    {{image "choises"}}
    <figcaption>Choises</figcaption>
  {{/thumbnail}}
  {{#thumbnail "col-sm-6"}}
    {{image "filter_by_keyword"}}
    <figcaption>Popup isearch by typing "f"</figcaption>
  {{/thumbnail}}
{{/thumbnails}}

The integration is easy. Load `popup.el`, implement one prompt function and
add it to `yas/prompt-functions`.

{{gist 2245733 "yasnippet-popup-isearch-prompt.el" lang="cl"}}

[yasnippet]: http://capitaomorte.github.com/yasnippet/index.html
[popup]: https://github.com/m2ym/popup-el
[auto-complete]: https://github.com/m2ym/auto-complete
