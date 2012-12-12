---
updated_at: <2012-01-23 19:26:16>
created_at: <2011-12-03 03:41:28>
title: Chef
tags: ruby, deploy
---

Installation
-------------

Install `chef-solo`:

    $ gem install chef

Resources
----------

Basic build block in recipe:

<http://wiki.opscode.com/display/chef/Resources>

Chef Repository
---------------

A GIT repository skeleton for cookbook development.

Add cookbook from [Opscode Community Cookbook Site](http://community.opscode.com/cookbooks):

    $ knife cookbook site install nodejs

`knife` requires a config file, have to create it in the repository in
`.chef/knife.rb`:

    node_name                'solo'
    client_key File.expand_path('../solo.pem', __FILE__)
    cache_type 'BasicFile'
    cache_options( :path => File.expand_path('../checksums', __FILE__))
    cookbook_path [ File.expand_path('../../cookbooks', __FILE__) ]

    cookbook_copyright "COMPANY"
    cookbook_license "none"
    cookbook_email "ian@example.com"

`solo.pem` is a private key. For `chef-solo`, just generate it using
`ssh-keygen`.

Directory Structure
-------------------

Files and templates are organized by server name or os system name.

Tips
----------

- `include_recipe` will run the included recipe.
- `attributes?`, `fetch` can only use string key.
