# -*- coding: utf-8 -*-
require 'nokogiri'

module Nanoc::Filters
  class Footnote < ::Nanoc::Filter
    # Preprocess in text anchor. The footnote footer should be inserted using
    # nokogiri filter :footnote_footer
    def run(content, params = {})
      prefix = [item[:uuid], 'fn'].compact.join('-')

      content.gsub(/\[\^(\d+)\](.?)/) do |match|
        number, suffix = $1, $2
        if suffix != ':'
          <<HTML
<sup class="fnref" id="#{prefix}ref-#{number}"><a href="##{prefix}-#{number}" rel="footnote">[#{number}]</a></sup>#{suffix}
HTML
        else
          match
        end
      end
    end
  end

  class FootnoteFooter < ::Nanoc::Filter
    def run(content, params = {})
      if content.is_a?(String)
        doc = ::Nokogiri::HTML.fragment(content)
      else
        doc = content
      end

      id_prefix = item[:uuid] || ''
      id_prefix += '-' unless id_prefix.empty?
      fn_prefix = [item[:uuid], 'fn'].compact.join('-')

      html = ''
      doc.css('p').each do |p|
        inner_html = p.inner_html
        if inner_html =~ /^\[\^(\d+)\]:/
          number = $1
          html << <<HTML
<li id="#{fn_prefix}-#{number}">#{p.inner_html.sub(/^[^:]*:/, ' ')}
<a href="##{fn_prefix}ref-#{number}" rev="footnote">↩</a></li>
HTML
          p.remove
        end
      end

      unless html.empty?
        footer = doc.at('footer')
        prefix = footer.nil? ? '<footer>' : ''
        prefix << %Q{<div class="footnotes"><h2 class="no-chapsec" id="#{id_prefix}footnotes">Footnotes</h2><ol>}
        prefix << html
        html = prefix

        html << '</ol></div>'
        html << '</footer>' if footer.nil?
        (footer || doc).add_child ::Nokogiri::HTML.fragment(html)
      end

      if content.is_a?(String)
        doc.to_html :encoding => 'UTF-8'
      else
        doc
      end
    end
  end
end

