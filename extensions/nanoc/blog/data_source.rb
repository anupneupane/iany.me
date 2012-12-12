require 'nanoc/blog/blog_data'
require 'nanoc/blog/item'

module Nanoc
  module Blog
    class ::Nanoc::Site
      def blogs
        @blogs ||= {}
      end

      def blog(name = :blog)
        blogs[name]
      end
    end

    class DataSource < Nanoc::DataSources::FilesystemUnified
      DEFAULT_CONFIG = {
        :name => 'blog',
        :directory => 'posts',
        :source => ':year-:month-:day-:title',
        :permlink => ':year/:month/:day/:title',
        :tag_template => '/tag/',
        :tag_permlink => '/tags/:tag/',
        :calendar_template => '/calendar/',
        :year_permlink => '/:year/',
        :sort => 'created_at DESC'
      }

      def initialize(*args)
        super
        @config = DEFAULT_CONFIG.merge(@config || {})
        @config[:permlink_regexp] = regexp_from_patten(@config[:permlink])
        @config[:source_regexp] = regexp_from_patten(@config[:source])
      end

      def create_object(dir_name, content, attributes, identifier, params = {})
        source = permlink_to_source(identifier)
        super(dir_name, content, attributes, source, params)
      end

      def items
        @items ||= load_items
      end

      def load_items
        items = load_objects(@config[:directory], 'item', ::Nanoc::Item).collect do |item|
          ::Nanoc::Blog::Item.create_from(item)
        end

        items.each do |item|
          item[:blog_name] = @config[:name]
          if !item.binary? && item[:filename] =~ @config[:source_regexp]
            item[:kind] ||= 'article'

            matches = $~
            names = matches.names
            now = Time.now
            year = names.include?('year') ? matches[:year] : now.year
            month = names.include?('month') ? matches[:month] : now.month
            day = names.include?('day') ? matches[:day] : 1

            item[:created_at] ||= Time.new(year, month, day)
            item[:updated_at] ||= item.mtime
            if names.include?('title')
              item[:title] ||= matches[:title].split(/[-_]/).collect(&:capitalize).join(' ')
            end
          end
        end

        @site.blogs[@config[:name].to_sym] = BlogData.new(items, @config)

        items
      end

      def layouts
        []
      end

      def identifier_for_filename(filename)
        source_to_permlink(super(filename))
      end

      def source_to_permlink(source)
        if matches = @config[:source_regexp].match(source)
          rep = format_pattern(@config[:permlink], matches)
          source.sub(@config[:source_regexp], rep)
        else
          source
        end
      end

      def permlink_to_source(permlink)
        if matches = @config[:permlink_regexp].match(permlink)
          rep = format_pattern(@config[:source], matches)
          permlink.sub(@config[:permlink_regexp], rep)
        else
          permlink
        end
      end

      def regexp_from_patten(pattern)
        str = Regexp.quote(pattern)
          .gsub(/:year/, '(?<year>\d{4})').gsub(/:(month|day)/, '(?<\1>\d{2})')
          .gsub(/:title/, '(?<title>[^/]+)')

        Regexp.new(str)
      end

      def format_pattern(pattern, params)
        params.names.each do |name|
          pattern = pattern.gsub(Regexp.new(":#{name}"), params[name])
        end
        pattern
      end
    end
  end
end
