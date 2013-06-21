require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'iany.me'
set :deploy_to, '/mnt/iany.me'
set :repository, 'git@github.com:doitian/iany.me.git'
set :branch, 'master'
set :forward_agent, true

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['MathJax', 'Font-Awesome', 'org-mode', 'gallery']

# Optional settings:
set :user, 'ian'
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared"]
  queue! %[git clone git://github.com/mathjax/MathJax.git "#{deploy_to}/shared/MathJax"]
  queue! %[git clone git://github.com/FortAwesome/Font-Awesome.git "#{deploy_to}/shared/Font-Awesome"]
  queue! %[git clone git://orgmode.org/org-mode.git "#{deploy_to}/shared/org-mode"]
end

namespace :deploy do
  # Copy gallery directory to content directory
  task :copy_gallery do
    queue %{
      echo "-----> Copying gallery directory"
      cp -r "#{deploy_to}/#{shared_path}/gallery" ./content
    }
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone_no_recursive'
    invoke :'deploy:link_shared_paths'
    invoke :'deploy:copy_gallery'
    invoke :'bundle:install'
    queue! echo_cmd(%[NANOC_ENV=server bundle exec nanoc compile])
    queue! echo_cmd(%[NANOC_ENV=server bundle exec nanoc gzip])
  end
end

namespace :git do
  desc "Clones the Git repository to release path without --recursive"
  task :clone_no_recursive do
    if revision?
      error "The Git option `:revision` has now been deprecated."
      error "Please use `:commit` or `:branch` instead."
      exit
    end

    clone = if commit?
      %[
        echo "-----> Using git commit '#{commit}'" &&
        #{echo_cmd %[git clone "#{repository!}" .]} &&
        #{echo_cmd %[git checkout -b current_release "#{commit}" --force]} &&
      ]
    else
      %{
        if [ ! -d "#{deploy_to}/scm/objects" ]; then
          echo "-----> Cloning the Git repository"
          #{echo_cmd %[git clone "#{repository!}" "#{deploy_to}/scm" --bare]}
        else
          echo "-----> Fetching new git commits"
          #{echo_cmd %[(cd "#{deploy_to}/scm" && git fetch "#{repository!}" "#{branch}:#{branch}" --force)]}
        fi &&
        echo "-----> Using git branch '#{branch}'" &&
        #{echo_cmd %[git clone "#{deploy_to}/scm" . --branch "#{branch}"]} &&
      }
    end

    status = %[
      echo "-----> Using this git commit" &&
      echo &&
      #{echo_cmd %[git --no-pager log --format="%aN (%h):%n> %s" -n 1]} &&
      #{echo_cmd %[rm -rf .git]} &&
      echo
    ]

    queue clone + status
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

