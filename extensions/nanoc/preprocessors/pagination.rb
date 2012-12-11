module Nanoc
  module Preprocessors
    class Pagination
      def self.configure
        yield new
      end

      def paginate(items, per_page, template, pattern)
        if items.size == 0
          attributes = template.attributes.dup
          attributes[:page_items] = items
          attributes[:page_num] = 1
          attributes[:page_totals] = 1
          items << ::Nanoc::Item.new(template.raw_content || template.raw_filename,
                                      attributes,
                                      pattern.gsub(/:num/, '1'),
                                      :binary => template.binary?,
                                      :mtime => template.mtime)
          return
        end

        items_slice = items.each_slice(per_page).to_a

        pages = Array.new(items_slice.size)

        items_slice.each_with_index { |page_items, i|
          page_num = i + 1

          attributes = template.attributes.dup
          attributes[:page_items] = page_items
          attributes[:page_num] = page_num
          attributes[:page_totals] = pages.size

          pages[i] = ::Nanoc::Item.new(template.raw_content || template.raw_filename,
                                       attributes,
                                       pattern.gsub(/:num/, (i + 1).to_s),
                                       :binary => template.binary?,
                                       :mtime => template.mtime)
        }

        pages.each_with_index do |item, i|
          item[:prev_page] = pages[i - 1] if i > 0
          item[:next_page] = pages[i + 1] if i < pages.size - 1
        end

        pages
      end
    end
  end
end
