module Jekyll
  module Polyglot
    module Liquid
      class UnrelativizedLinkBlock < ::Liquid::Block
        def initialize(tag_name, params, tokens)
          super
          # finds and assigns the given attributes to a created
          attributes = {}
          href_attrs = params.split
          href_attr_map = href_attrs.each do |attribute|
            splitup = attribute.split "="
            if splitup.length == 2 then
              @attr_hash[splitup[0]] = splitup[1]
            end
          end
          attributes = ["class", "href", "rel", "target"]
          attributes.map {|x|  }
          
        end

        def render(context)
          text = super
          # TODO
          xhref="xhref=#{@attr_hash['href']}"
          xclass= @attr_hash['class'] ? "class=#{@attr_hash['class']}" : ""
          xrel= @attr_hash['rel'] ? "rel=#{@attr_hash['rel']}" : ""
          xtarget= @attr_hash['target'] ? "target=#{@attr_hash['target']}" : ""
          "<a #{xhref} #{xclass} #{xrel} #{xtarget}>#{text}</a>"
        end
      end
    end
  end
end

Liquid::Template.register_tag('Unrelativized_Link', Jekyll::Polyglot::Liquid::UnrelativizedLinkBlock)
