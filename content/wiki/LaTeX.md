---
title: LaTeX
created_at: <2013-04-11 17:31:33>
updated_at: <2013-05-03 01:07:37>
tags: [latex]
---

## Math

### Hyphen in math

Define a new math character:

```latex
\mathchardef\mhyphen="2D

\[ {d\mhyphen sep}_G(X,Y|Z) \]
```

Use `amsmath` (`amsopn`) command `\operatorname`

```latex
\[ \operatorname{d-sep}_G(X,Y|Z) \]
```

### Affixing symbols to other symbols

Commands `overset` and `underset` in `amsmath` (`amsopn`)

## Package Conflicts

e.g. `wasysym` and `amsmath` both defines `iiint` and `iint`

```latex
\usepackage{wasysym}
\usepackage{savesym}
\savesymbol{iiint}%hide iiint in wasysym
\savesymbol{iint}
\usepackage{amsmath}
%can restore wasysym iiint and rename amsmath version as AMSiiint
%\restoresymbol[AMS]{iiint}
```
