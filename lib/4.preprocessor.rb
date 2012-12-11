require 'mini_magick'

class ::Nanoc::Site
  def item_of
    @item_of ||= {}
  end
end


class Preprocessor
  def self.configure(site)
    instance = new(site)
    if block_given?
      yield instance
    else
      instance.run_all
    end
  end

  attr_reader :site
  attr_reader :config
  attr_reader :items
  attr_reader :layouts

  def initialize(site)
    @site = site
    @config = site.config
    @items = site.items
    @layouts = site.layouts
  end

  def run_all
    setup_env
    paginate
    index_items
    fill_image_dimensions
    nomalize_attributes
    split_extension
    setup_layout
    register_handlebars_helpers
    setup_sitemap
  end

  def paginate
    ::Nanoc::Preprocessors::Pagination.configure do |config|
      template = items.find { |item| item.identifier == '/' }
      items.delete template
      site.blog.items.delete template

      # blog index pagination
      pages = config.paginate site.blog.articles, 10, template, '/p:num'
      site.blog.items.concat pages
      items.concat pages
    end
  end

  def index_items
    return if @indexed
    @indexed = true
    items.each do |item|
      site.item_of[item.identifier] = item
    end
  end

  def fill_image_dimensions
    items.each do |item|
      if %w(jpg png).include?(item[:extension])
        image = MiniMagick::Image.open(item.raw_filename)
        item[:width] = image[:width]
        item[:height] = image[:height]
      end
    end
  end

  def nomalize_attributes
    items.each do |item|
      item[:site] ||= 'blog'
      item[:kind] ||= 'page'
      item[:tags] ||= []
      item[:created_at] = parse_time(item[:created_at])
      item[:updated_at] = parse_time(item[:updated_at])
      if item[:title].nil?
        item[:title] = File.basename(item.identifier.chop).gsub(/[-_ ]+/, ' ').capitalize
      elsif item[:title] == false
        item[:title] = nil
      end
    end
  end

  def split_extension
    items.each do |item|
      html_extensions = %w(erb md markdown hb hbs handlebars)

      extensions = item[:extension].split('.')
      if html_extensions.include?(extensions.first)
        extensions.unshift 'html'
      end
      item[:split_extensions] = extensions
    end
  end

  def setup_layout
    site.blog.items.each do |item|
      item[:sidebar] = true if item[:sidebar].nil?
      if item[:kind] == 'article'
        item[:page_layout] = 'blog'
        item[:comment] = true if item[:comment].nil?
      end
    end
  end

  def register_handlebars_helpers
    HandlebarsHelpers.site = site
    HandlebarsHelpers.methods(false).each do |method|
      proc = HandlebarsHelpers.method(method).to_proc
      site.handlebars.register_helper(method, &proc)
    end
  end

  def setup_sitemap
    index_items
    site.blog.articles.each do |item|
      item[:changefreq] ||= config[:sitemap][:default][:changefreq]
      item[:priority] ||= config[:sitemap][:default][:priority]
    end

    home = site.item_of['/p1/']
    home[:changefreq] ||= config[:sitemap][:index][:changefreq]
    home[:priority] ||= config[:sitemap][:index][:priority]

    site.blog.tags.each do |tag, page|
      page[:changefreq] ||= config[:sitemap][:tag][:changefreq]
      page[:priority] ||= config[:sitemap][:tag][:priority]
    end

    site.blog.calendar.each do |year, page|
      page[:changefreq] ||= config[:sitemap][:calendar][:changefreq]
      page[:priority] ||= config[:sitemap][:calendar][:priority]
    end
  end

  def setup_env
    if ENV['NANOC_ENV'] == 'server'
      config[:env] = :server
    else
      config[:env] = :local
    end
  end

  private
  def parse_time(time)
    if time.is_a?(Date)
      Time.new(time.year, time.month, time.day)
    elsif time.is_a?(String)
      Time.parse(time)
    else
      time
    end
  end
end
