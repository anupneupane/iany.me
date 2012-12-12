require 'mini_magick'

usage       'favicon'
summary     'Generate favicons from misc/favicon.svg'

favicon_formats = {
  'apple-touch-icon-114x114-precomposed.png' => '114x114',
  'apple-touch-icon-144x144-precomposed.png' => '144x144',
  'apple-touch-icon-57x57-precomposed.png' => '57x57',
  'apple-touch-icon-72x72-precomposed.png' => '72x72',
  'apple-touch-icon.png' => '57x57',
  'apple-touch-icon-precomposed.png' => '57x57',
  'favicon.ico' => '16x16'
}

run do |opts, args, cmd|
  source = File.expand_path('misc/favicon.svg')

  outdir = File.expand_path('content')

  favicon_formats.each do |basename, size|
    puts "generate #{basename}"
    format = File.extname(basename)[1..-1]
    image = MiniMagick::Image.open(source)
    image.resize size
    image.format format
    image.write File.join(outdir, basename)
  end
end
