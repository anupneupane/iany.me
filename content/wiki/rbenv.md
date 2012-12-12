---
title: rbenv
created_at: <2011-12-13 09:39:29>
updated_at: <2012-12-12 07:07:03>
tags: [ruby]
---

[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh

Installation
------------

Download this script
[rbenv-installer](https://github.com/fesplugas/rbenv-installer/blob/master/rbenv-installer.sh),
review its content and execute it. Add your plugins in the `PLUGINS` array. For
example, I added `rbenv-gemset`:

```sh
PLUGINS=( "sstephenson:rbenv-vars"
          "sstephenson:ruby-build"
          "jamis:rbenv-gemset" )
```

Follow the [instructions](https://github.com/sstephenson/rbenv) to setup.

Integration with ZSH
--------------------

### Show rbenv version in prompt ###

If [oh-my-zsh][] theme is used, the simplest solution is overriding `rvm-prompt`
and `rvm_prompt_info`.

```sh
function rbenv_prompt_info() {
  local ruby_version
  ruby_version=$(rbenv version 2> /dev/null) || return
  echo "‹$ruby_version" | sed 's/[ \t].*$/›/'
}
alias rvm-prompt=rbenv_prompt_info
alias rvm_prompt_info=rbenv_prompt_info
```

Add this snippet into file 'rbenv.zsh' in oh-my-zsh custom directory, which is
`$HOME/.zsh/custom` by default.

I customize the theme myself, so I just use it directly in my PROMPT:

```sh
PROMPT='╭─%~ $(git_prompt_info) $(rbenv_prompt_info)
╰─› '
```


Gemsets
-------


### Use Bundler ###

Set `path` to `vender/bundler` in global config

<div class="caption">$HOME/.bundle/config</div>

```yaml
---
BUNDLE_PATH: vendor/bundle
```

In the projects having Gemfile, `bundle install` will install all gems into
`vendor/bundle` in current directory.

The option `--system` cannot override path in global config file. To install
into system gems directory, use following command:

    $ bundle install --path "$(gem environment gemdir)"
    
If several projects are related and share most gems, they also can share the
same bundle install path to avoid installing duplicated gems. Just create a
directory for the projects and run `bundle install` with option `--path`
pointing to that directory.

To ease using `bundle exec`, create an alias for it

    alias b='bundle exec'

Or just load `oh-my-zsh` plugin
[bundler](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/bundler/bundler.plugin.zsh),
which setup alias for frequently used commends and prefix `bundle exec` if
Gemfile is found in current directory or any parent directory.

But the `eval` is slow on my laptop, so I use `bundler-exec` function in alias
and setup the zsh completion function `_bundler-exec`:

<%= gist_caption 1470370, 'bundler.zsh' %>

```sh
bundled_commands=(cap capify cucumber foreman guard heroku nanoc3 rackup rails rainbows rake rspec ruby shotgun spec spork thin unicorn unicorn_rails)

_bundler-installed() {
  which bundle > /dev/null 2>&1
}

_within-bundled-project() {
  local check_dir=$PWD
  while [ "$(dirname $check_dir)" != "/" ]; do
    [ -f "$check_dir/Gemfile" ] && return
    check_dir="$(dirname $check_dir)"
  done
  false
}

bundler-exec() {
  if _bundler-installed && _within-bundled-project; then
    bundle exec "$@"
  else
    "$@"
  fi
}

def _bundler-exec() {
  local curcontext="$curcontext" environ e
  zstyle -a "$curcontext" environ environ

  for e in "${environ[@]}"
  do local -x "$e"
  done
  _arguments \
    '(-):command name: _command_names -e'  \
    '*::arguments: _normal'
}

compdef _bundler-exec bundler-exec

## Main program
for cmd in $bundled_commands; do
  alias $cmd="bundler-exec $cmd"
done
```

### Use rbenv-gemset ###

See [rbenv-gemset git repo](https://github.com/jamis/rbenv-gemset). I prefer
bundler path. But sometimes I use `rbenv-gemset`.

If some projects share most gems, instead of creating a directory as shared
bundle install path, I use `rbenv-gemset`'s gem home.

1.  Create a file `.rbenv-gemsets`, and add a line containing gemset name in it.
2.  Run `bundle install` and set path to gem home.

        $ bundle install --path "$(gem environment gemdir)"

I also created a gemset with name 'docs'. I install gems into this gemset, than
start a yard server to show documentations.

    $ mkdir ~/.ruby_docs
    $ cd ~/.ruby_docs
    $ echo 'docs' > .rbenv-gemsets
    $ gem install rails rspec yard yard-doc-core thin
    $ yard server -m -g -s thin

Local ruby version does not work in tmuxinator session
------------------------------------------------------

Because tmuxinator is a ruby gem, it set `RBENV_DIR` already. And `rbenv`
searchs local `.rbenv-version` starting from `RBENV_DIR` then its parent
directories until root if `RBENV_DIR` is set. So just clear it and let rbenv
searches from currenct directory. It can be done in a pre step.

<%= caption 'reset_rbenv_dir.yml' %>
```yaml
project_name: Reset RBENV_DIR
project_root: /tmp
pre:
  - export RBENV_DIR=
tabs:
  - shell:
```

