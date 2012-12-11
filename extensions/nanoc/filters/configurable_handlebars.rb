# encoding: utf-8

require 'handlebars'

module Nanoc::Filters
  class ConfigurableHandlebars < ::Nanoc::Filter
    class ::Nanoc::Site
      def handlerbars
        @handlerbars ||= ::Handlerbars::Context.new
      end
    end

    def run(content, params={})
      context = item.attributes.dup
      context[:item]   = assigns[:item].attributes
      context[:layout] = assigns[:layout] ? assigns[:layout].attributes : assigns[:layout]
      context[:config] = assigns[:config]
      context[:yield]  = assigns[:content]

      template = site.handlerbars.compile(content)
      template.call(context)
    end
  end
end
