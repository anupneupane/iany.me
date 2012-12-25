---
updated_at: <2012-12-21 13:09:13>
created_at: <2012-12-21 13:05:11>
title: CSS
tags: [css, web, design]
---

Tricks
------

-   clearfix

    ```css
    .group:before, .group:after {
      content: "";
      display: table;
    } 
    .group:after { clear: both; }
    .group { zoom: 1; /* IE6&7 */ }
    ```
