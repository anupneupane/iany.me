require 'nokogiri'

module Nanoc::Filters
  class LatexEscape < ::Nanoc::Filter
    def run(doc, options = nil)
      if content.is_a?(String)
        doc = Nokogiri::HTML.fragment(content)
      else
        doc = content
      end

      doc.css('code:not(.mathjax)').each do |code|
        html = code.inner_html
        if html.size > 2 && html.start_with?('$') && html.end_with?('$')
          if code['class'] && !code['class'].empty?
            code['class'] << ' mathjax'
          else
            code['class'] = 'mathjax'
          end
          code['lang'] = 'latex'
          code.inner_html = ::Nokogiri::HTML.fragment(html[1...-1])
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
