module Jekyll
  module Polyglot
    module Liquid
      class I18nHeadersTag < ::Liquid::Tag
        def initialize(tag_name, text, tokens)
          super
          @url = text
          @url.strip!
          @url.chomp! '/'
        end

        def render(context)
          site = context.registers[:site]
          permalink = context.registers[:page]['permalink']
          permalink_lang = context.registers[:page]['permalink_lang']
          site_url = @url.empty? ? site.config['url'] : @url
          i18n = "<meta http-equiv=\"Content-Language\" content=\"#{site.active_lang}\">\n"
          i18n += "<link rel=\"alternate\" hreflang=\"#{site.default_lang}\" "\
          "href=\"#{site_url}#{permalink}\"/>\n"
          site.languages.each do |lang|
            next if lang == site.default_lang

            url = permalink_lang && permalink_lang[lang] ? permalink_lang[lang] : permalink
            i18n += "<link rel=\"alternate\" hreflang=\"#{lang}\" "\
            "href=\"#{site_url}/#{lang}/#{url}\"/>\n"
          end
          i18n
        end
      end
    end
  end
end

Liquid::Template.register_tag('I18n_Headers', Jekyll::Polyglot::Liquid::I18nHeadersTag)
Liquid::Template.register_tag('i18n_headers', Jekyll::Polyglot::Liquid::I18nHeadersTag)
