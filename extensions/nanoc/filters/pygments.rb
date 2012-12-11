require 'pygments'

# Make pygments.rb works on Arch Linux
# I also need to create a symbol link:
# use python2 if default is 3
if `python --version 2>&1` =~ /\s3\./
  require 'pygments/popen'

  module Pygments
    module Popen
      alias_method :posix_popen4, :popen4

      def popen4(command)
        posix_popen4 "/usr/bin/env python2.7 #{command}"
      end
    end
  end
end


module Nanoc::Filters
  class Pygments < ::Nanoc::Filter
    def run(content, params = {})
      if content.is_a?(String)
        doc = Nokogiri::HTML.fragment(content)
      else
        doc = content
      end

      doc.search("pre>code").each do |node|
        lang = node.attr('class')
        if lang && !lang.strip.empty? && lang != 'mathjax'
          s = node.inner_html || "[++where is the code?++]"
          begin
            node.parent.swap(pygment(s, lang.strip, params))
          rescue MentosError
            # ignore
          end
        end
      end

      if content.is_a?(String)
        doc.to_html :encoding => 'UTF-8'
      else
        doc
      end
    end

    private
    def pygment(str, lang, params)
      str = unescape_html(str)
      ::Pygments.highlight(str, :lexer => lang, :formatter => 'html', :options => params)
    end
    def unescape_html(str)
      str.to_s.gsub(/&#x000A;/i, "\n").gsub("&lt;", '<').gsub("&gt;", '>').gsub("&amp;", '&')
    end
  end
end
