require 'sass'

# Use SASS as CSS compressor, because CSS is also valid SCSS file
class CssCompressor
  def compress(css)
    if css.count("\n") > 2
      Sass::Engine.new(css,
                       :syntax => :scss,
                       :cache => false,
                       :read_cache => false,
                       :style => :compressed).render
    else
      css
    end
  end
end

::Nanoc::Sprockets::DataSource.configure do |assets|
  if ENV['NANOC_ENV'] == 'server'
    assets.js_compressor = Uglifier.new
    assets.css_compressor = CssCompressor.new
  end
end
