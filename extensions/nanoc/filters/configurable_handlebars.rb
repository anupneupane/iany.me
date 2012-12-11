# encoding: utf-8

require 'handlebars'

module Nanoc::Filters
  class ConfigurableHandlebars < ::Nanoc::Filter
    class ::Nanoc::Site
      def handlebars
        @handlebars ||= ::Handlebars::Context.new
      end
    end
    class ::Handlebars::Context
      attr_accessor :item
    end

    def run(content, params={})
      context = item.attributes.dup
      context[:item]   = assigns[:item].attributes
      context[:layout] = assigns[:layout] ? assigns[:layout].attributes : assigns[:layout]
      context[:config] = assigns[:config]
      context[:yield]  = assigns[:content]

      template = site.handlebars.compile(content)
      remember = site.handlebars.item
      site.handlebars.item = item
      result = template.call(context)
      site.handlebars.item = remember
      result
    end
  end
end
