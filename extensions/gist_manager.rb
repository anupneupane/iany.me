# From Octopress
#
# A Liquid tag for Jekyll sites that allows embedding Gists and showing code for non-JavaScript enabled browsers and readers.
# by: Brandon Tilly
# Source URL: https://gist.github.com/1027674
# Post http://brandontilley.com/2011/01/31/gist-tag-for-jekyll.html

require 'cgi'
require 'digest/md5'
require 'net/https'
require 'uri'

class GistManager
  class << self
    def instance
      @instance ||= new
    end

    attr_writer :instance

    def gist(*args)
      instance.gist(*args)
    end
  end

  def initialize(cache_folder = '.gist-cache')
    if cache_folder
      @cache_folder = File.expand_path(cache_folder)
      FileUtils.mkdir_p @cache_folder
    end
  end

  def gist(gist, file, options = {})
    version    = options[:version]
    code       = get_cached_gist(gist, file, version) || get_gist_from_web(gist, file, version)
    code_caption = code_caption(gist, file)
    html_output_for gist, file, code, code_caption, options
  end

  def html_output_for(gist, file, code, code_caption, options)
    code = CGI.escapeHTML code
    code_attr = ''
    if options[:lang]
      code_attr = %Q( class="#{options[:lang]}")
    end
    if options[:version]
      code_attr = %Q( data-version="#{options[:version]}")
    end
    <<-HTML
<div class="gist" data-gist-id="#{gist}" data-gist-file="#{file}">
  <pre><code#{code_attr}>#{code}</code></pre>
  #{code_caption}
</div>
    HTML
  end

  def get_gist_url_for(gist, file)
    "https://raw.github.com/gist/#{gist}/#{file}"
  end

  def code_caption(gist, file)
    <<-HTML
<div class="code-caption">
<a class="code-filename" href="https://gist.github.com/#{gist}##{file}">#{file}</a>
<span class="code-meta">
  <a href="https://gist.github.com/#{gist}">This Gist</a> brought to you by <a href="http://github.com">GitHub</a>.
</span>
</div>
    HTML
  end

  def cache(gist, file, data, version)
    cache_file = get_cache_file_for gist, file, version
    File.open(cache_file, "w") do |io|
      io.write data
    end
  end

  def get_cached_gist(gist, file, version)
    return nil unless @cache_folder
    cache_file = get_cache_file_for gist, file, version
    File.read cache_file if File.exist? cache_file
  end

  def get_cache_file_for(gist, file, version)
    bad_chars = /[^a-zA-Z0-9\-_.]/
    gist      = gist.to_s.gsub bad_chars, ''
    file      = file.gsub bad_chars, ''
    vesrion   = (version || '').to_s.gsub bad_chars, ''
    md5       = Digest::MD5.hexdigest "#{gist}-#{file}-#{version}"
    File.join @cache_folder, "#{gist}-#{file}-#{md5}.cache"
  end

  def get_gist_from_web(gist, file, version)
    gist_url          = get_gist_url_for gist, file
    raw_uri           = URI.parse gist_url
    proxy             = ENV['http_proxy']
    if proxy
      proxy_uri       = URI.parse(proxy)
      https           = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new raw_uri.host, raw_uri.port
    else
      https           = Net::HTTP.new raw_uri.host, raw_uri.port
    end
    https.use_ssl     = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request           = Net::HTTP::Get.new raw_uri.request_uri
    data              = https.request request
    data              = data.body
    cache gist, file, data, version if @cache_folder
    data
  end
end

