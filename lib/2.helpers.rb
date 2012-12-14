require 'nokogiri'

include Nanoc::Helpers::HTMLEscape
include Nanoc::Helpers::Capturing
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Breadcrumbs
include Nanoc::Blog::Helpers

module SiteHelpers
  def title_tag
    title = item[:title]
    if title
      "<title>~ian/#{item[:site]}$ #{html_escape(title)}</title>"
    else
      "<title>~ian/#{item[:site]}</title>"
    end
  end

  def body_class
    classes = []

    classes.push 'with-sidebar' if item[:sidebar]
    classes.push 'with-comments' if item[:comment]
    classes.push 'with-mathjax' if item[:mathjax]

    if item[:class]
      classes += item[:class] if item[:class].is_a?(Array)
      classes.push item[:class] if item[:class].is_a?(String)
    end

    classes.push item[:kind] if item[:kind]
    classes.push active_menu.to_s

    classes.compact.uniq.join(' ')
  end

  def active_menu
    return item[:menu].to_sym if item[:menu]

    case item[:kind]
    when 'page', 'article'
      :blog
    else
      (item[:kind] || :blog).to_sym
    end
  end

  def tag(name, attributes = {})
    attributes = attributes.collect do |key, value|
      %Q(#{key}="#{html_escape(value.to_s)}")
    end.join(' ')

    "<#{name} #{attributes} />"
  end

  def content_tag(name, content = nil, attributes = {}, &block)
    if content.is_a?(Hash)
      attributes = content
      content = nil
    end

    if block
      begin
        content = capture(&block)
      rescue NameError
        content = block.call
      end
    end

    attributes = attributes.collect do |key, value|
      %Q(#{key}="#{html_escape(value.to_s)}")
    end.join(' ')

    <<-HTML
<#{name} #{attributes}>#{content}</#{name}>

    HTML
  end

  def stylesheet_link_tag(name)
    tag :link, {
      :href => "/assets/#{name}.css",
      :rel => 'stylesheet',
      :type => 'text/css'
    }
  end

  def javascript_include_tag(name)
    content_tag :script, {
      :src => "/assets/#{name}.js",
      :type => 'text/javascript'
    }
  end

  def feed_content(item)
    doc = Nokogiri::HTML.fragment(item.compiled_content(:snapshot => :pre))

    doc.search('img').each do |img|
      if img[:src] =~ /^\//
        img[:src] = config[:base_url] + img[:src]
      end
    end
    doc.search('a').each do |a|
      if a[:href] =~ /^\//
        a[:href] = config[:base_url] + a[:href]
      end
    end

    doc.to_html :encoding => 'UTF-8'
  end
end

include SiteHelpers
