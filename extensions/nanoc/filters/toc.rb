require 'nokogiri'

module Nanoc
  module Filters
    class TOC < ::Nanoc::Filter
      def run(content, params = {})
        params = {
          :article_selector => '#main article',
          :append_to => '#toc section'
        }.merge(params)

        doc = ::Nokogiri::HTML(content)
        headers = []

        doc.css(params[:article_selector]).first.css('h2,h3,h4').each do |header|
          if header[:id].start_with?('toc_')
            level = header.name.sub(/^h/, '').to_i - 1
            order = header[:id].sub(/^toc_/, '').to_i
            headers.push(level: level, id: header[:id], text: header.text, order: order)
          elsif header[:id].end_with?('footnotes')
            level = header.name.sub(/^h/, '').to_i - 1
            order = 9999
            headers.push(level: level, id: header[:id], text: header.text, order: order)
          end
        end

        inner_html = headers.sort_by {|header| header[:order]}.collect do |header|
          %Q[<li class="toc-level-#{header[:level]}"><a href="##{header[:id]}">#{header[:text]}</a></li>]
        end.join("\n")

        if doc.css('#comments').size > 0
          inner_html += %Q[<li class="toc-level-1"><a href="#comments">Comments</a></li>]
        end

        html = ['<ol>', inner_html, '</ol>'].join("\n")

        doc.search(params[:append_to]).first << html

        doc.to_html :encoding => 'UTF-8'
      end
    end
  end
end
