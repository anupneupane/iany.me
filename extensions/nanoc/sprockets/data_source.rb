require 'sprockets'
require 'sprockets-sass'
require 'sass'

module Nanoc
  module Sprockets
    class DataSource < Nanoc::DataSource
      attr_reader :environment

      def self.configure(environment = nil, &block)
        @block = block if block
        @block.call(environment) if environment
      end

      def items
        assets.collect do |asset|
          ext = File.extname(asset.logical_path)[1..-1]

          attributes = {
            :filename => asset.logical_path,
            :extension => ext
          }

          binary = !@site.config[:text_extensions].include?(ext)

          params = {
            :binary => binary,
            :mtime => asset.mtime
          }

          Nanoc::Item.new(binary ? asset.pathname.to_s : asset.to_s,
                          attributes,
                          asset.logical_path.chomp(".#{ext}"),
                          params)
        end
      end

      def up
        @environment = build_environment
        self.class.configure(@environment)
      end

      private
      def assets
        environment.each_logical_path.collect do |path|
          unless path =~ %r(/_|^_)
            if @site.config[:text_extensions].include?(File.extname(path)[1..-1])
              environment[path] if @config[:precompile].include?(path)
            else
              environment[path]
            end
          end
        end.compact
      end

      def build_environment
        ::Sprockets::Environment.new.tap do |env|
          @config[:gems].each do |gem|
            before_gem(gem[:name])
            gem_root = Gem.loaded_specs[gem[:name]].full_gem_path
            gem[:load_paths].each do |path|
              env.append_path File.join(gem_root, path)
            end
            after_gem(gem[:name])
          end

          @config[:load_paths].each do |path|
            env.append_path path
          end
        end
      end

      def before_gem(name)
      end

      def after_gem(name)
        case name
        when 'bootstrap-sass'
          prefix = @config[:image_path_prefix]
          Sass::Script::Functions.class_eval do
            # Define image_path for Compass to allow use of sprites without url() wrapper.
            define_method :image_path do |asset, options = {}|
              asset_sans_quotes = asset.value.gsub('"', '')
              path = File.join(prefix, asset_sans_quotes)
              Sass::Script::String.new(path, :string)
            end
          end
        end
      end
    end
  end
end
