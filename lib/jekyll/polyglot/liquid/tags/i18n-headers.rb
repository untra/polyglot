module Jekyll
  module Polyglot
    module Liquid
      class HreflangTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
          super
        end

        def render(context)
          site = context.registers[:site]
          permalink = context.registers[:page]['permalink']
          i18n = "<meta http-equiv=\"Content-Language\" content=\"#{site.active_lang}\">"
          i18n += "<link rel=\"alternate\" i18n=\"#{site.default_lang}\""\
          " href=\"http://yoursite.com#{permalink}\" />\n"
          site.languages.each do |lang|
            next if lang == site.default_lang
            i18n += "<link rel=\"alternate\" i18n=\"#{lang}\""\
            " href=\"http://yoursite.com/#{lang}#{permalink}\" />\n"
          end
          i18n
        end
      end
    end
  end
end

Liquid::Template.register_tag('i18n-headers', Jekyll::Polyglot::Liquid::RenderTimeTag)
