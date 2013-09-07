require 'nanoc/filters/configurable_handlebars'
require 'gist_manager'

module HandlebarsHelpers
  module_function

  def info(this, title = nil, callback = nil)
    callout this, 'info', title, callback
  end
  def warning(this, title = nil, callback = nil)
    callout this, 'warning', title, callback
  end
  def danger(this, title = nil, callback = nil)
    callout this, 'danger', title, callback
  end

  def callout(this, type = 'default', title = nil, callback = nil)
    if type.is_a?(V8::Function)
      callback = type
      type = nil
    elsif title.is_a?(V8::Function)
      callback = title
      title = nil
    end

    content = []
    content << content_tag(:h4, h(title)) if title
    content << redcarpet.render(callback.call)

    html = content_tag :div, content.join("\n"), :class => "callout callout-#{type}"
    Handlebars::SafeString.new(html)
  end

  def gist(this, gist, file, object = {})
    attributes = v8_object_to_hash(object['hash'] || {})
    Handlebars::SafeString.new(GistManager.gist(gist, file, attributes))
  end

  def figure(this, html_class = '', callback = nil)
    if html_class.is_a?(V8::Function)
      callback = html_class
      html_class = ''
    end

    html = content_tag :figure, callback.call, :class => 'thumbnail ' + html_class
    html = content_tag :div, html
    Handlebars::SafeString.new(html)
  end

  def thumbnails(this, html_class = '', callback = nil)
    if html_class.is_a?(V8::Function)
      callback = html_class
      html_class = ''
    end

    ul = content_tag :div, callback.call, :class => 'thumbnails'
    html = content_tag :figure, ul, :class => html_class

    Handlebars::SafeString.new(html)
  end

  # thumbnail with only one image
  def thumbnail(this, html_class = '', callback = nil)
    if html_class.is_a?(V8::Function)
      callback = html_class
      html_class = ''
    end

    div = content_tag :div, callback.call, :class => 'thumbnail'
    html = content_tag :div, div, :class => html_class

    Handlebars::SafeString.new(html)
  end

  def pathFor(this, name)
    if name.start_with?('/')
      identifier = name
    else
      identifier = (site.handlebars.item.identifier + name).chomp('/') + '/'
    end

    site.item_of[identifier].path
  end

  def urlFor(this, name)
    config[:base_url] + path(this, name)
  end

  def image(this, name, object = {})
    attributes = v8_object_to_hash(object['hash'] || {})

    if name.start_with?('http')
      attributes[:src] = name
    else
      if name.start_with?('/')
        image = site.item_of[identifier]
      else
        attributes[:alt] ||= name.gsub(/[-_ ]+/, ' ')
        image = site.item_of['/gallery' + (site.handlebars.item.identifier + name).chomp('/') + '/']
      end

      attributes[:width] ||= image[:width]
      attributes[:height] ||= image[:height]
      attributes[:src] = image.path
    end

    Handlebars::SafeString.new tag(:img, attributes)
  end

  def caption(this, kind, object = {})
    attributes = v8_object_to_hash(object['hash'] || {})
    file = attributes[:file] || ''
    description = attributes[:desc] || ''

    html = <<-HTML
<div class="code-caption">
  <span class="code-filename">#{h file}</span>
  <span class="code-meta">#{h description}</span>
</div>
    HTML

    Handlebars::SafeString.new html
  end

  def more
    html = tag :hr, :id => 'read-on'
    Handlebars::SafeString.new html
  end

  def site
    self.class.site
  end

  def v8_object_to_hash(object)
    hash = {}
    object.each do |k, v|
      unless k == 'hash'
        hash[k.to_sym] = v.is_a?(V8::Object) ? v8_object_to_hash(v) : v
      end
    end
    hash
  end

  def redcarpet
    return @redcarpet if @redcarpet
    renderer = OEmbedHtmlRenderer.new(with_toc_data: false)
    options = {
      :no_intra_emphasis => true,
      :tables => true,
      :fenced_code_blocks => true,
      :autolink => true
    }
    ::Redcarpet::Markdown.new(renderer, options)
  end

  class << self
    attr_accessor :site
  end
end
