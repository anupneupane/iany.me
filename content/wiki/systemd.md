---
title: systemd
created_at: <2013-02-26 16:53:57>
updated_at: <2013-02-26 16:59:34>
tags: [linux]
---

unit template

unit template
-------------

Template file name contains `@` at the end such as `netcfg@.service`.

Enable/start a service `netcfg@wlan` will generate from the template by
replacing `%i`.

auto amount
-----------

Add following mount option:

    noauto,x-systemd.automount

