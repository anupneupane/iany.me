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
            a << ' <i class="icon-external-link"></i>'

            unless a['class'].include?('no-icon')
              case domain
              when 'plus.google.com'
                a['class'] += " icon icon-google-plus-sign"
              when /twitter\.com$/
                a['class'] += " icon icon-twitter-sign"
              when /github\.com$/
                a['class'] += " icon icon-github-sign"
              when /facebook\.com$/
                a['class'] += " icon icon-facebook-sign"
              when /linkedin.com$/
                a['class'] += " icon icon-linkedin-sign"
              end
            end
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
