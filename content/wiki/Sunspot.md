---
updated_at: <2012-01-22 01:17:45>
created_at: <2011-12-03 03:40:47>
title: Sunspot
tags: solr, search, ruby, rails
---

<http://outoftime.github.com/sunspot/>

Hack
----

### Adjust params

```ruby
adjust_solr_params do |params|
  params['q'] = "awesome AND #{params['q']}"
end
```

### Build search incremental


```ruby
search = Sunspot.new_search(SeachableModel)
search.build {
  keywords "google"
}
search.build {
  paginate :page => 1, :per_page => 20
}
search.execute
```

### Get underlying request params


```ruby
search = Sunspot.new_search(SeachableModel) {
  keywords "google"
  paginate :page => 1, :per_page => 20
}
search.query.to_params
```

So it can be used in RSolr

```ruby
rsolr.request '/select', params
```

### Get underlying rsolr connection ###

```ruby
Sunspot.new_search(SeachableModel).instance_variable_get(:@connection)
```

Deploy
------

### Capistrano ###

Create shared data dir

```ruby
namespace :deploy do
  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/data"
  end
end

after 'deploy:setup', 'deploy:setup_solr_data_dir'
```

Start, stop, reindex

```ruby
namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data"
    start
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec rake sunspot:solr:reindex"
  end
end
```


Test
----

See sunspot wiki about [RSpec-and-Sunspot](https://github.com/outoftime/sunspot/wiki/RSpec-and-Sunspot)


### Stubbing out

```ruby
require 'sunspot/rails/spec_helper'

Spec::Runner.configure do |config|
  config.before(:each) do
    ::Sunspot.session = ::Sunspot::Rails::StubSessionProxy.new(::Sunspot.session)
  end

  config.after(:each) do
    ::Sunspot.session = ::Sunspot.session.original_session
  end
end
```

### Running Sunspot on demand

```ruby
# spec/support/sunspot.rb
$original_sunspot_session = Sunspot.session
Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)

require 'socket'
require 'timeout'

module SolrSpecHelper

  def solr_setup
    unless $sunspot
      $sunspot = Sunspot::Rails::Server.new

      pid = fork do
        STDERR.reopen('/dev/null')
        STDOUT.reopen('/dev/null')
        $sunspot.run
      end
      # shut down the Solr server
      at_exit { Process.kill('TERM', pid) }
      # wait for solr to start
      counter = 10
      until is_port_open?('127.0.0.1', $sunspot.port)
        counter -= 1
        raise "Failed to start solr" if counter == 0
        sleep 3
      end
    end

    Sunspot.session = $original_sunspot_session
  end
  
  def is_port_open?(ip, port)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false
  end
end
```

```ruby
# spec/foo/bar_spec.rb
  before(:all) do
    solr_setup
  end

  after(:all) do
    YourModel.remove_all_from_index!
  end
  
  # use Sunspot.commit to force indexing all documents
```
