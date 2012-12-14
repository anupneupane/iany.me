require 'zlib'
require 'stringio'
require 'find'

usage       'gzip'
summary     'GZip files for Nginx gzip_static'

favicon_formats = {
  'apple-touch-icon-114x114-precomposed.png' => '114x114',
  'apple-touch-icon-144x144-precomposed.png' => '144x144',
  'apple-touch-icon-57x57-precomposed.png' => '57x57',
  'apple-touch-icon-72x72-precomposed.png' => '72x72',
  'apple-touch-icon.png' => '57x57',
  'apple-touch-icon-precomposed.png' => '57x57',
  'favicon.ico' => '16x16'
}

# middlemain-more/extensions/gzip.rb
def gzip_file(path)
  input_file = File.open(path, 'rb').read
  output_filename = path + '.gz'
  input_file_time = File.mtime(path)

  # Check if the right file's already there
  if File.exist?(output_filename) && File.mtime(output_filename) == input_file_time
    return
  end

  File.open(output_filename, 'wb') do |f|
    gz = Zlib::GzipWriter.new(f, Zlib::BEST_COMPRESSION)
    gz.mtime = input_file_time.to_i
    gz.write input_file
    gz.close
  end

  # Make the file times match, both for Nginx's gzip_static extension
  # and so we can ID existing files. Also, so even if the GZ files are
  # wiped out by build --clean and recreated, we won't rsync them over
  # again because they'll end up with the same mtime.
  File.utime(File.atime(output_filename), input_file_time, output_filename)

  old_size = File.size(path)
  new_size = File.size(output_filename)

  [output_filename, old_size, new_size]
end

run do |opts, args, cmd|
  Dir['output/**/*.{js,css,html,htm,xml,json,txt}'].each do |path|
    output_filename, old_size, new_size = gzip_file(path.to_s)

    if output_filename
      size_change_word = (old_size - new_size) > 0 ? 'smaller' : 'larger'
      puts "[gzip] #{output_filename} (#{(old_size - new_size).abs} #{size_change_word})"
    end
  end
end
