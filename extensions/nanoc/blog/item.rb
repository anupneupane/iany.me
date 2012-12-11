module Nanoc
  module Blog
    class Item < Nanoc::Item
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

        if self[:created_at].is_a?(String)
          self[:created_at] = Time.parse(self[:created_at])
        end
      end
    end
  end
end
