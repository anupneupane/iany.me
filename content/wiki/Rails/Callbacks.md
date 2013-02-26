---
title: Callbacks
created_at: <2013-02-26 17:03:22>
updated_at: <2013-02-26 17:10:27>
tags: [ruby, rails]
---


`define_model_callbacks` adds custom callbacks to model. See also
[ActiveSupport::Callbacks][0]

    define_model_callbacks :import, :only => [:before, :after, :around]
    after :import, :touch_imported_at

`run_callbacks` to run all registered callbacks

    run_callbacks :import do
      ...
    end
    
`run_callbacks` can pass arguments, e.g.:

    run_callbacks :import, 'csv' do
      ...
    end
    
TODO: how to use the arguments in `:if`, `:unless`, `:only`, `:except`.
    
[0]: http://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html
