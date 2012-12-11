module Nanoc
  module Blog
    module Helpers
      class ::Nanoc::Site
        def summary_store
          @summary_store ||= SummaryStore.new
        end
      end

      class SummaryStore
        def initialize
          @store = {}
        end

        def cache(item, &block)
          @store[item.identifier] ||= block.call
        end
      end

      def item_summary(item)
        cache = site.summary_store.cache(item) {
          extract_item_summary(item)
        }

        cache.first
      end

      def item_more?(item)
        cache = site.summary_store.cache(item) {
          extract_item_summary(item)
        }

        cache.last
      end

      def extract_item_summary(item)
        full = item.compiled_content(:snapshot => :pre)
        doc = ::Nokogiri::HTML.fragment(full)
        more = doc.css('#read-on').first
        if more
          summary = ''
          doc.children.each do |e|
            break if e == more
            summary << e.to_html(encoding: 'UTF-8')
          end
        else
          summary = full
        end

        [summary, !!more]
      end
    end
  end
end
