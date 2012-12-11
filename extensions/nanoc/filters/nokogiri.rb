require 'nokogiri'

module Nanoc::Filters
  module Nokogiri
    class Build < ::Nanoc::Filter
      def run(content, params = {})
        ::Nokogiri::HTML.fragment(content)
      end
    end

    class Write < ::Nanoc::Filter
      def run(content, params = {})
        content.to_html :encoding => 'UTF-8'
      end
    end
  end
end
