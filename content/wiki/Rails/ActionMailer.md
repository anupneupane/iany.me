---
updated_at: <2012-12-16 21:55:54>
created_at: <2011-12-03 03:40:47>
title: ActionMailer
tags: web, rails, ruby, mail
---

Use helpers
-----------

```ruby
class ReportMailer < ActionMailer::Base
  add_template_helper(AnnotationsHelper)

  ...
end
```

Test
----

- [mail_safe](https://github.com/myronmarston/mail_safe)
- [mails_viewer](https://github.com/pragmaticly/mails_viewer)
