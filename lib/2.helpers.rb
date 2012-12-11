include Nanoc::Helpers::HTMLEscape
include Nanoc::Helpers::Capturing
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Blog::Helpers

module SiteHelpers
  def title_tag
    title = item_title(item)
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

    classes += item[:class] if item[:class]

    classes.push item[:kind] if item[:kind]
    classes.push active_menu.to_s

    classes.compact.uniq.join(' ')
  end

  def item_title(item)
    content_for(item, :title) || item[:title]
  end

  def active_menu
    if item[:kind] == 'page'
      :blog
    else
      (item[:kind] || :blog).to_sym
    end
  end

  def tag(name, attributes = nil)
    attributes = attributes.collect do |key, value|
      %Q(#{key}="#{html_escape(value)}")
    end.join(' ')

    "<#{name} #{attributes} />"
  end

  def content_tag(name, content = nil, attributes = nil, &block)
    if content.is_a?(Hash)
      attributes = content
      content = nil
    end

    content = capture(&block) if block
    attributes = attributes.collect do |key, value|
      %Q(#{key}="#{html_escape(value)}")
    end.join(' ')

    "<#{name} #{attributes}>#{content}</#{name}>"
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
end

include SiteHelpers
