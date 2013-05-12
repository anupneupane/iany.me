require 'mini_magick'
require 'uglifier'

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
    link_mathjax
    link_font_awesome
    paginate
    index_items
    fill_image_dimensions
    nomalize_attributes
    split_extension
    setup_layout
    register_handlebars_helpers
    setup_sitemap
    generate_item_uuid
    setup_breadcrumbs
  end

  def link_mathjax
    unless File.exist?('output/assets/MathJax')
      FileUtils.mkdir_p 'output/assets'
      system "ln -sfn '../../MathJax' output/assets/MathJax"
    end
  end

  def link_font_awesome
    FileUtils.mkdir_p 'output/assets'
    system "ln -sfn '../../Font-Awesome/font' output/assets/font"
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
      item[:sidebar] = true if item[:sidebar].nil?

      if item.identifier.start_with?('/wiki/')
        item[:site] = 'wiki'
        item[:menu] = 'wiki'
      end

      item[:site] ||= 'blog'
      item[:kind] ||= 'page'
      item[:tags] ||= []
      if item[:tags].is_a?(String)
        item[:tags] = item[:tags].split(',')
      end
      item[:tags] = item[:tags].compact.collect(&:strip).reject(&:empty?).collect(&:downcase).uniq

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
      html_extensions = %w(erb md markdown hb hbs handlebars org)

      extensions = item[:extension].split('.')
      if html_extensions.include?(extensions.first)
        extensions.unshift 'html'
      end
      item[:split_extensions] = extensions
    end
  end

  def setup_layout
    site.blog.items.each do |item|
      if item[:kind] == 'article'
        item[:page_layout] = 'blog'
        item[:comment] = true if item[:comment].nil?
      end
    end
    site.blog(:wiki).items.each do |item|
      if item[:kind] == 'article'
        item[:page_layout] = 'wiki'
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

    home = site.item_of['/p1/']
    home[:changefreq] ||= config[:sitemap][:index][:changefreq]
    home[:priority] ||= config[:sitemap][:index][:priority]

    wiki = site.item_of['/wiki/']
    wiki[:changefreq] ||= config[:sitemap][:wiki_index][:changefreq]
    home[:priority] ||= config[:sitemap][:wiki_index][:priority]

    site.blog.articles.each do |item|
      item[:changefreq] ||= config[:sitemap][:default][:changefreq]
      item[:priority] ||= config[:sitemap][:default][:priority]
    end
    site.blog(:wiki).articles.each do |item|
      item[:changefreq] ||= config[:sitemap][:default][:changefreq]
      item[:priority] ||= config[:sitemap][:default][:priority]
    end

    site.blog.tags.each do |tag, page|
      page[:changefreq] ||= config[:sitemap][:tag][:changefreq]
      page[:priority] ||= config[:sitemap][:tag][:priority]
    end
    site.blog(:wiki).tags.each do |tag, page|
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

  def generate_item_uuid
    items.each do |item|
      unless item.binary?
        words = File.basename(item.identifier.chomp('/')).split(/[^a-zA-Z0-9]+/).compact
        words = words.collect(&:strip).collect(&:downcase).reject { |word|
          word.size <= 1 || %w{the an is are was were be}.include?(word)
        }

        prefix_words = words[0, 3]
        prefix_words << words[-1] if words.size > 3
        if prefix_words.empty? ||
            prefix_words.collect { |w| w.size }.inject(&:+) <= 8
          item[:uuid] = prefix_words.join
        else
          item[:uuid] = prefix_words.collect { |w| w[0, 2] }.join
        end
      end
    end
  end

  def setup_breadcrumbs
    site.blog.tags.each do |tag, page|
      page[:breadcrumbs] ||= ['/archives/', '/tags/']
    end
    site.item_of['/tags/'][:breadcrumbs] = ['/archives/']
    site.blog.calendar.each do |year, page|
      page[:breadcrumbs] = ['/archives/']
    end

    site.blog(:wiki).tags.each do |tag, page|
      page[:breadcrumbs] ||= ['/wiki/', '/wiki-tags/']
    end
    site.blog(:wiki).articles.each do |page|
      page[:breadcrumbs] ||= breadcrumbs_for_identifier(page.identifier)[1...-1].compact
    end
    site.item_of['/wiki-tags/'][:breadcrumbs] = ['/wiki/']

    items.each do |item|
      if item[:breadcrumbs]
        item[:breadcrumbs] = item[:breadcrumbs].collect { |crumb|
          if crumb.is_a?(String)
            title, identifier = crumb.split('|', 2)
            if identifier.nil?
              identifier = title
              title = nil
            end
            item = site.item_of[identifier]
            raise "Cannot find #{identifier}" unless item
            [title || item[:title], item]
          else
            [crumb[:title], crumb]
          end
        }
      end
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
