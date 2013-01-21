require 'oembed'
require 'redcarpet'
require 'uri'

OEmbed::Providers.register_all(:aggregators)

class OEmbedHtmlRenderer < Redcarpet::Render::HTML
  def image(link, title, alt_text)
    oembed = OEmbed::Providers.get(link)
    %q(<div class="media embedded embeded-%s embeded-%s">%s</div>) % [oembed.type, oembed.provider_name.downcase.gsub(/[ .]/, '-'), oembed.html]
  rescue OEmbed::NotFound
    %q(<img src="%s" title="%s" alt="%s" />) % [link, title, alt_text].collect { |txt| URI.escape(txt.to_s) }
  end
end
