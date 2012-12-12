module Nanoc
  module Blog
    class Item < Nanoc::Item
      def self.create_from(item)
        new(item.raw_filename || item.raw_content,
            item.attributes,
            item.identifier,
            :binary => item.binary?,
            :mtime => item[:mtime])
      end

      def initialize(*args)
        super

        normalize!
      end

      def tags
        self[:tags]
      end

      def date
        self[:created_at]
      end

      def title
        self[:title]
      end

      def normalize!
        self[:tags] ||= []
        if self[:tags].is_a?(String)
          self[:tags] = self[:tags].split(',')
        end

        self[:tags] = self[:tags].compact.collect(&:strip).reject(&:empty?).collect(&:downcase).uniq

        self[:created_at] = parse_time(self[:created_at])
        self[:updated_at] = parse_time(self[:updated_at] || self.mtime)
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
  end
end
