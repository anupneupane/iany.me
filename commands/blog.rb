require 'handlebars'

usage       'blog title'
summary     'Create a new blog post'

option :t, :tags, 'list of tags separated by comma', :argument => :required
option :s, :slug, 'specify slug manually', :argument => :required

STOP_WORDS = %w{the an is are was were be}

run do |opts, args, cmd|
  title = args.join(' ')
  slug = opts[:slug] || title.split(/\s+/).collect(&:downcase)
    .reject { |w| w.size <= 1 || STOP_WORDS.include?(w) }.join('-')

  now = Time.now
  date = now.strftime('%Y-%m-%d')
  time = now.strftime('%Y-%m-%d %H:%M:%S')

  path = File.expand_path(File.join('content/posts', "#{date}-#{slug}.html.md"))
  if File.exists?(path)
    $stderr.puts "File already exists"
    exit 1
  end
  handlebars = ::Handlebars::Context.new
  context = {
    :updated_at => time,
    :created_at => time,
    :title => title,
    :tags => opts[:tags] || ''
  }
  template = handlebars.compile(BLOG_TEMPLATE)
  result = template.call(context)
  File.open(path, 'w') do |f|
    f.write(result)
  end
  unless ENV['EMACS']
    system "emacs-dwim -n #{path}"
  end
end

BLOG_TEMPLATE = <<HB
---
updated_at: <{{updated_at}}>
created_at: <{{created_at}}>
title: {{title}}
tags: [{{tags}}]
---

HB
