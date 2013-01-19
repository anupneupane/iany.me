load 'deploy' if respond_to?(:namespace) # cap2 differentiator

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

require 'bundler/capistrano'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "iany.me"
set :repository,  "git@github.com:doitian/iany.me.git"
set :deploy_to, '/mnt/iany.me'

set :scm, :git
set :branch, 'master'
set :checkout, 'export'
set :deploy_via, :remote_cache
set :keep_releases, 3

set :user, 'ian'
set :use_sudo, true

server "iany.me", :app

# after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :symlink_mathjax do
    run "rm -rf #{current_release}/MathJax && ln -nfs #{shared_path}/MathJax #{latest_release}/MathJax"
  end
  task :symlink_font_awesome do
    run "ln -nfs #{shared_path}/Font-Awesome #{latest_release}/Font-Awesome"
  end
  task :compile do
    run "cd #{current_release} && NANOC_ENV=server bundle exec nanoc compile"
  end
  task :gzip do
    run "cd #{current_release} && NANOC_ENV=server bundle exec nanoc gzip"
  end
end

after 'deploy:update_code', 'deploy:symlink_mathjax'
after 'deploy:update_code', 'deploy:symlink_font_awesome'
after 'deploy:update_code', 'deploy:compile'
after 'deploy:update_code', 'deploy:gzip'
