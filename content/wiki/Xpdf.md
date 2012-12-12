---
updated_at: <2011-12-08 06:33:45>
created_at: <2011-12-03 03:40:47>
title: Xpdf
tags: Linux
---

Fonts
----------

### Use GhostScript fonts in Arch Linux

Install `gsfonts`:


```console
$ [sudo] pacman -S gsfonts
```

Update config file `/etc/xpdfrc`. Add following lines.

~~~
displayFontT1 Times-Roman /usr/share/fonts/Type1/n021003l.pfb
displayFontT1 Times-Italic /usr/share/fonts/Type1/n021023l.pfb
displayFontT1 Times-Bold /usr/share/fonts/Type1/n021004l.pfb
displayFontT1 Times-BoldItalic /usr/share/fonts/Type1/n021024l.pfb
displayFontT1 Helvetica /usr/share/fonts/Type1/n019003l.pfb
displayFontT1 Helvetica-Oblique /usr/share/fonts/Type1/n019023l.pfb
displayFontT1 Helvetica-Bold /usr/share/fonts/Type1/n019004l.pfb
displayFontT1 Helvetica-BoldOblique /usr/share/fonts/Type1/n019024l.pfb
displayFontT1 Courier /usr/share/fonts/Type1/n022003l.pfb
displayFontT1 Courier-Oblique /usr/share/fonts/Type1/n022023l.pfb
displayFontT1 Courier-Bold /usr/share/fonts/Type1/n022004l.pfb
displayFontT1 Courier-BoldOblique /usr/share/fonts/Type1/n022024l.pfb
displayFontT1 Symbol /usr/share/fonts/Type1/s050000l.pfb
displayFontT1 ZapfDingbats /usr/share/fonts/Type1/d050000l.pfb

fontDir /usr/share/fonts/Type1
fontDir /usr/share/fonts/TTF

enableT1lib yes
enableFreeType yes
antialias yes
~~~
