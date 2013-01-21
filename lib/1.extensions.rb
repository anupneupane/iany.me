$: << File.expand_path('../../extensions', __FILE__)

require 'nanoc/extensions'
require 'oembed_html_renderer'

Nanoc::Filters::Erubis::ErubisWithErbout.send :include, ::Erubis::EscapeEnhancer
