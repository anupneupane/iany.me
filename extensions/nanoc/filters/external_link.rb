require 'nokogiri'

module Nanoc::Filters
  class ExternalLink < ::Nanoc::Filter
    def run(content, options = nil)
      if content.is_a?(String)
        if content =~ /!DOCTYPE/
          doc = ::Nokogiri::HTML(content)
        else
          doc = ::Nokogiri::HTML.fragment(content)
        end
      else
        doc = content
      end

      doc.css('a:not(.external)').each do |a|
        if a['href'] =~ %r{^(?:https?|ftp)://([^/]+)}
          domain = $1
          unless domain.end_with?(site.config[:base_url].split('://', 2).last)
            a['class'] = "#{a['class']} external"
            a['data-domain'] = domain
            a << ' <i class="icon-external-link"></i>'
          end
        end
      end

      if content.is_a?(String)
        doc.to_html :encoding => 'UTF-8'
      else
        doc
      end
    end
  end
end
