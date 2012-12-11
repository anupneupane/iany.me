module Nanoc
  module Blog
    class BlogData
      def initialize(items, config)
        @items = items
        @config = config

        @tag_template = @items.find { |item| item.identifier == @config[:tag_template] }
        @calendar_template = @items.find { |item| item.identifier == @config[:calendar_template] }

        raise "Tag template cannot be found" unless @tag_template
        raise "Calendar template cannot be found" unless @tag_template

        @items.delete @tag_template
        @items.delete @calendar_template

        @articles = @items.find_all { |item| item[:kind] == 'article' }
          .sort_by(&:date).reverse

        @items.concat create_tag_items
        @items.concat create_calendar_items
      end

      def name
        @config[:name]
      end

      def create_tag_items
        grouped = {}
        @articles.each do |article|
          article.tags.each do |tag|
            grouped[tag] ||= []
            grouped[tag] << article
          end
        end

        @tags = {}
        grouped.each { |tag, articles|
          content = @tag_template.raw_content
          attributes = @tag_template.attributes.dup
          attributes[:page_items] = articles
          attributes[:tag] = tag
          attributes[:kind] = 'archives'

          @tags[tag] = ::Nanoc::Item.new(content,
                                         attributes,
                                         @config[:tag_permlink].gsub(/:tag/, tag.to_s),
                                         :binary => @tag_template.binary?,
                                         :mtime => @tag_template.mtime)
        }
        @tags.values
      end

      def create_calendar_items
        grouped = @articles.group_by { |article| article.date.year }

        @calendar = {}
        grouped.each { |year, articles|
          content = @calendar_template.raw_content
          attributes = @calendar_template.attributes.dup
          attributes[:page_items] = articles
          attributes[:page_type] = 'year'
          attributes[:year] = year
          attributes[:kind] = 'archives'

          @calendar[year] = ::Nanoc::Item.new(content,
                                              attributes,
                                              @config[:year_permlink].gsub(/:year/, year.to_s),
                                              :binary => @calendar_template.binary?,
                                              :mtime => @calendar_template.mtime)
        }
        @calendar.values
      end

      attr_reader :items
      attr_reader :articles
      attr_reader :tags
      attr_reader :calendar
    end
  end
end
