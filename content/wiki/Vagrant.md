---
updated_at: <2011-12-03 03:43:33>
created_at: <2011-12-03 03:40:47>
title: Vagrant
tags: ruby, virtualbox, virtual
---

Get Started
-------------

    $ gem install vagrant
    $ vagrant box add lucid32 http://files.vagrantup.com/lucid32.box
    $ vagrant init lucid32
    # edit Vagrantfile
    $ vagrant up

Control VM
-----------

- `vagrant up|halt`: start and power off
- `vagrant suspend|resume`: sleep and resume
- `vagrant ssh`: connect vm using SSH

Vagrantfile
----------------

-   Port binding

        config.vm.forward_port name, guest_port, host_port
