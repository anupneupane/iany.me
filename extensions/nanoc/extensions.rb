require 'nanoc'

module Nanoc::Filters
  autoload 'ConfigurableHandlebars', 'nanoc/filters/configurable_handlebars'
  autoload 'Nokogiri', 'nanoc/filters/nokogiri'
  autoload 'Pygments', 'nanoc/filters/pygments'

  Nanoc::Filter.register '::Nanoc::Filters::ConfigurableHandlebars', :configurable_handlebars
  Nanoc::Filter.register '::Nanoc::Filters::Nokogiri::Build', :nokogiri_build
  Nanoc::Filter.register '::Nanoc::Filters::Nokogiri::Write', :nokogiri_write
  Nanoc::Filter.register '::Nanoc::Filters::Pygments', :pygments
end

module Nanoc::DataSources
  autoload 'IgnoreableFilesystemUnified', 'nanoc/data_sources/ignoreable_filesystem_unified'

  Nanoc::DataSource.register '::Nanoc::DataSources::IgnoreableFilesystemUnified', :ignoreable_filesystem_unified
end

require 'nanoc/preprocessors/pagination'
require 'nanoc/sprockets'
require 'nanoc/blog'


