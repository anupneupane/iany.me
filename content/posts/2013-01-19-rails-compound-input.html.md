---
updated_at: <2013-01-19 21:47:51>
created_at: <2013-01-19 18:06:16>
title: Rails Compound Input
tags: [rails]
tmpl: hb
toc: true
---

When I implement
[time input feature](https://github.com/saberma/19wu/pull/160) for
[19wu](https://github.com/saberma/19wu) (an open source ticket sale system), I
want to split the datetime into date and time parts, so JavaScript date picker
and time picker can be used. This post introduces two methods I found.

{{#figure "center"}}
  {{image "compound_datetime_input"}}
  <figcaption>Compound datetime input</figcaption>
{{/figure}}

`composed_of` utilizes `assign_multiparameter_attributes` trick like
`datetime_select`, and `fields_for` mocks an association.

The github repository [doitian/rails-compound-input-demo](https://github.com/doitian/rails-compound-input-demo) contains demos for both methods.

{{more}}

composed_of
-----------

Rails has built-in compound inputs `date_select`, `time_select` and
`datetime_select`. They use trick that if parameter name has parentheses, they
will be used in the attribute class constructor (see
[assign_multiparameter_attributes][]). However, datetime attribute is of type
DateTime, which accepts 6 parameters year, month, day, hour, minute and
second.

[composed_of][] can be used here to represent the datetime attribute using
value object, which class constructor accepts date and time strings. See
`CompoundDatetime#initialize` below.

```ruby
class CompoundDatetime
  def self.from_datetime(datetime)
    new.tap do |result|
      result.datetime = datetime
    end
  end

  attr_accessor :datetime

  # Accepts date and time string. The form just need to submit params
  #
  #   - compound_beginning_time(1s) for date
  #   - compound_beginning_time(2s) for time
  def initialize(date = nil, time = nil)
    if date.present?
      @datetime = Time.zone.parse([date.presence, time.presence || ''].join(' '))
    end
  end

  def date
    @datetime.strftime('%Y-%m-%d') if @datetime
  end

  def time
    @datetime.strftime('%H:%M') if @datetime
  end
end
```

<div class="code-caption">
<a class="code-filename" href="https://github.com/doitian/rails-compound-input-demo/blob/master/composed_of/app/models/compound_datetime.rb">compound_datetime.rb</a>
</div>

Then setup the mapping in model `Event`:

```ruby
class Event < ActiveRecord::Base
  attr_accessible :beginning_time, :title
  attr_accessible :compound_beginning_time

  composed_of :compound_beginning_time, {
    :class_name => 'CompoundDatetime',
    :mapping => [ %w(beginning_time datetime) ],
    :converter => Proc.new { |datetime| CompoundDatetime.from_datetime(datetime) }
  }
end
```

<div class="code-caption">
<a class="code-filename" href="https://github.com/doitian/rails-compound-input-demo/blob/master/composed_of/app/models/event.rb">event.rb</a>
</div>

The form view just needs set correct name:

```rhtml
<div class="field">
  <%= f.label :compound_beginning_time, 'Begining Time' %><BR />
  <%= text_field_tag 'event[compound_beginning_time(1s)]', @event.compound_beginning_time.date, :placeholder => 'yyyy-mm-dd' %>
  <%= text_field_tag 'event[compound_beginning_time(2s)]', @event.compound_beginning_time.time, :placeholder => 'HH:MM' %>
</div>
```

<div class="code-caption">
<a class="code-filename" href="https://github.com/doitian/rails-compound-input-demo/blob/master/composed_of/app/views/events/_form.html.erb">events/_form.html.erb</a>
</div>

fields_for
----------

`fields_for` is usually used to embed associations in
form. However,

> all it required was a method to return the named attribute, and then a
> `<field>_attributes=` writer to interpret the hash on the other side.
> <small>[Compound Attributes and fields_for in Rails | Wondible](http://wondible.com/2011/06/11/compound-attributes-and-fields_for-in-rails/)</small>

First create `CompoundDatetime` class which exposes date and time
fields. `assign_attributes` handles the hash params passed from form. Method
`persisted?` is required to quiet `NoMethodError`.

```ruby
class CompoundDatetime
  attr_accessor :datetime

  def initialize(datetime)
    @datetime = datetime
  end

  # accepts hash like:
  #
  #     {
  #       'date' => '2012-12-20',
  #       'time' => '20:30'
  #     }
  def assign_attributes(hash)
    if hash[:date].present?
      @datetime = Time.zone.parse([hash[:date].presence, hash[:time].presence || ''].join(' '))
    end
    self
  end

  def date
    @datetime.strftime('%Y-%m-%d') if @datetime
  end

  def time
    @datetime.strftime('%H:%M') if @datetime
  end

  def persisted?; false; end
end
```

<div class="code-caption">
<a class="code-filename" href="https://github.com/doitian/rails-compound-input-demo/blob/master/fields_for/app/models/compound_datetime.rb">compound_datetime.rb</a>
</div>

The model just delegates the named attribute and `<field>_attributes=` method to `CompoundDatetime`.

```ruby
class Event < ActiveRecord::Base
  attr_accessible :beginning_time, :title

  attr_accessible :compound_beginning_time_attributes

  def compound_beginning_time
    CompoundDatetime.new(beginning_time)
  end

  def compound_beginning_time_attributes=(attributes)
    self.beginning_time = compound_beginning_time.assign_attributes(attributes).datetime
  end
end
```

<div class="code-caption">
<a class="code-filename" href="https://github.com/doitian/rails-compound-input-demo/blob/master/fields_for/app/models/event.rb">event.rb</a>
</div>

The form view uses `fields_for` helper to nest fields of `compound_begining_time`.

```rhtml
<div class="field">
  <%= f.label :beginning_time %><br />
  <%= f.fields_for :compound_beginning_time do |fields| %>
    <%= fields.text_field :date, :placeholder => 'yyyy-mm-dd' %>
    <%= fields.text_field :time, :placeholder => 'HH:MM' %>
  <% end %>
</div>
```

<div class="code-caption">
<a class="code-filename" href="https://github.com/doitian/rails-compound-input-demo/blob/master/fields_for/app/views/events/_form.html.erb">events/_form.html.erb</a>
</div>

Reference
---------

- [Alex Rothenberg - How to use dates in Rails when your database stores a string](http://www.alexrothenberg.com/2009/05/21/how-to-use-dates-in-rails-when-your.html)
- [Compound Attributes and fields_for in Rails | Wondible](http://wondible.com/2011/06/11/compound-attributes-and-fields_for-in-rails/)
- [Ruby on Rails Guides: Rails Form helpers](http://guides.rubyonrails.org/form_helpers.html)
- [assign_multiparameter_attributes][]
- [composed_of][]

[assign_multiparameter_attributes]: http://apidock.com/rails/ActiveRecord/AttributeAssignment/assign_multiparameter_attributes "ActiveRecord::AttributeAssignment#assign_multiparameter_attributes"
[composed_of]: http://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html#method-i-composed_of "ActiveRecord::Aggregations.composed_of"
