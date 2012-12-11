$: << File.expand_path('../../extensions', __FILE__)

require 'nanoc/extensions'

Nanoc::Filters::Erubis::ErubisWithErbout.send :include, ::Erubis::EscapeEnhancer
