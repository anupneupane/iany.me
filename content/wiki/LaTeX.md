---
title: LaTeX
created_at: <2013-04-11 17:31:33>
updated_at: <2013-04-11 17:37:17>
tags: [latex]
---

** Math

*** Hyphen in math

Define a new math character:

```latex
\mathchardef\mhyphen="2D

\[ {d\mhyphen sep}_G(X,Y|Z) \]
```

Use `amsmath` command `\operatorname`

```latex
\[ \operatorname{d-sep}_G(X,Y|Z) \]
```

