require 'handlebars'

usage       'wiki title'
summary     'Create a new wiki page'

option :t, :tags, 'list of tags separated by comma', :argument => :required
option :s, :slug, 'specify slug manually', :argument => :required

run do |opts, args, cmd|
  title = args.first

  now = Time.now
  date = now.strftime('%Y-%m-%d')
  time = now.strftime('%Y-%m-%d %H:%M:%S')

  path = File.expand_path(File.join('content/wiki', "#{title}.md"))
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
  template = handlebars.compile(WIKI_TEMPLATE)
  result = template.call(context)
  FileUtils.mkdir_p(File.dirname(path))
  File.open(path, 'w') do |f|
    f.write(result)
  end
  system "emacs-dwim -n #{path}"
end

WIKI_TEMPLATE = <<HB
---
updated_at: <{{updated_at}}>
created_at: <{{created_at}}>
title: {{title}}
tags: [{{tags}}]
---

HB
