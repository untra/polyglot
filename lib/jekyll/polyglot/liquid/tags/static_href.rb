module Jekyll
  module Polyglot
    module Liquid
      class StaticHrefTag < ::Liquid::Block
        def render(context)
          text = super
          href_attrs = text.strip.split('=', 2)
          valid = (href_attrs.length == 2 && href_attrs[0] == 'href') && href_attrs[1].start_with?('"') && href_attrs[1].end_with?('"')
          unless valid
            raise Liquid::SyntaxError, "static_href parameters must include match href=\"...\" attribute param, eg. href=\"http://example.com, href=\"/about\", href=\"/\" , instead got:\n#{text}"
          end

          href_value = href_attrs[1]
          # href writes out as ferh="..." explicitly wrong, to be caught by separate processor for nonrelativized links
          "ferh=#{href_value}"
        end
      end
    end
  end
end

Liquid::Template.register_tag('Static_Href', Jekyll::Polyglot::Liquid::StaticHrefTag)
Liquid::Template.register_tag('static_href', Jekyll::Polyglot::Liquid::StaticHrefTag)
