begin
  require 'pry'
rescue LoadError => e
  # ignore
end

$: << File.expand_path('../../extensions', __FILE__)

require 'nanoc/extra/file_proxy'
require 'erubis'
require 'nanoc/extensions'
require 'oembed_html_renderer'

Nanoc::Filters::Erubis::ErubisWithErbout.send :include, ::Erubis::EscapeEnhancer

class Nanoc::Extra::FileProxy
  def respond_to?(meth, include_private = false)
    file_instance_methods.include?(meth.to_sym)
  end
end
