module Nanoc::Filters
  class Wikilink < ::Nanoc::Filter
    include ::Nanoc::Helpers::HTMLEscape

    def run(content, params = {})
      content.gsub(/(^|.)\[\[(.*?[^:])\]\]/) do |match|
        prefix, inner = $1, $2.strip
        if prefix == '\\'
          match[1..-1]
        else
          title, link = inner.split('|', 2)
          if link.nil?
            link = title
            title = nil
          end

          identifiers = []
          dir = File.dirname(item.identifier.chomp('/'))
          identifiers.push File.expand_path(link, dir).chomp('/') + '/'
          identifiers.push File.expand_path(link, item.identifier.chomp('/')).chomp('/') + '/'

          target = find_item(identifiers)
          if target
            %Q[#{prefix}<a href="#{target.path}">#{html_escape(title || target[:title] || link)}</a>]
          else
            dir = File.dirname(item.path.chomp('/'))
            path = File.expand_path(link, dir)
            %Q[#{prefix}<a class="missing" href="#{html_escape(path)}">#{html_escape(title || link)}</a>]
          end
        end
      end
    end

    def find_item(identifiers)
      if site.respond_to?(:item_of)
        found = nil
        identifiers.each do |identifier|
          break if found = site.item_of[identifier]
        end
        found
      else
        items.find { |item| identifiers.include?(item.identifier) }
      end
    end
  end
end

