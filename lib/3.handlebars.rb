require 'nanoc/filters/configurable_handlebars'
require 'gist_manager'

module HandlebarsHelpers
  module_function

  def gist(this, gist, file, options = {}, &block)
    Handlebars::SafeString.new(GistManager.gist(gist, file, options))
  end

  def figure(this, html_class = '', callback = nil)
    if html_class.is_a?(V8::Function)
      callback = html_class
      html_class = ''
    end

    html = content_tag :figure, :class => 'thumbnail ' + html_class do
      callback.call
    end

    Handlebars::SafeString.new(html)
  end

  def thumbnails(this, html_class = '', callback = nil)
    if html_class.is_a?(V8::Function)
      callback = html_class
      html_class = ''
    end

    html = content_tag :figure, :class => html_class do
      content_tag :ul, :class => 'thumbnails' do
        callback.call
      end
    end

    Handlebars::SafeString.new(html)
  end

  # thumbnail with only one image
  def thumbnail(this, html_class = '', callback = nil)
    if html_class.is_a?(V8::Function)
      callback = html_class
      html_class = ''
    end

    html = content_tag :li, :class => html_class do
      content_tag :div, :class => 'thumbnail' do
        callback.call.to_s
      end
    end

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
    attributes = v8_object_to_hash(object)

    if name.start_with?('http')
      attributes[:src] = name
    else
      if name.start_with?('/')
        image = site.item_of[identifier]
      else
        attributes[:alt] ||= name.gsub(/[-_ ]+/, ' ')
        image = site.item_of[(site.handlebars.item.identifier + name).chomp('/') + '/']
      end

      attributes[:width] ||= image[:width]
      attributes[:height] ||= image[:height]
      attributes[:src] = image.path
    end

    Handlebars::SafeString.new tag(:img, attributes)
  end

  def site
    self.class.site
  end

  def v8_object_to_hash(object)
    hash = {}
    object.each do |k, v|
      unless k == 'hash'
        hash[k] = v.is_a?(V8::Object) ? v8_object_to_hash(v) : v
      end
    end
    hash
  end

  class << self
    attr_accessor :site
  end
end
