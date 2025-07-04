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
          page = context.registers[:page]
          permalink = page['permalink'] || page['url'] || ''
          permalink = "/#{permalink}" unless permalink.start_with?("/")
          page_id = page['page_id']
          permalink_lang = page['permalink_lang']
          baseurl = site.config['baseurl'] || ''
          site_url = @url.empty? ? site.config['url'] + baseurl : @url
          i18n = "<meta http-equiv=\"Content-Language\" content=\"#{site.active_lang}\">\n"

          # Find all documents with the same page_id
          docs_with_same_id = site.collections.values
            .flat_map(&:docs)
            .filter { |doc| !doc.data['page_id'].nil? }
            .select { |doc| doc.data['page_id'] == page_id }

          # Build a hash of lang => permalink for all matching docs
          lang_to_permalink = docs_with_same_id.to_h { |doc| [doc.data['lang'], doc.data['permalink']] }

          # Canonical should always point to the current page's permalink (active_lang)
          current_lang = site.active_lang
          current_permalink = lang_to_permalink[current_lang] || (permalink_lang && permalink_lang[current_lang]) || permalink
          current_permalink = "/#{current_permalink}" unless current_permalink.start_with?("/")
          current_lang_prefix = current_lang == site.default_lang ? '' : "/#{current_lang}"
          i18n += "<link rel=\"canonical\" href=\"#{site_url}#{current_lang_prefix}#{current_permalink}\"/>\n"

          site.languages.each do |lang|
            alt_permalink = lang_to_permalink[lang] || (permalink_lang && permalink_lang[lang]) || permalink
            alt_permalink = "/#{alt_permalink}" unless alt_permalink.start_with?("/")
            i18n += if lang == site.default_lang
              "<link rel=\"alternate\" hreflang=\"#{lang}\" href=\"#{site_url}#{alt_permalink}\"/>\n" \
                "<link rel=\"alternate\" hreflang=\"x-default\" href=\"#{site_url}#{alt_permalink}\"/>\n"
            else
              "<link rel=\"alternate\" hreflang=\"#{lang}\" href=\"#{site_url}/#{lang}#{alt_permalink}\"/>\n"
            end
          end
          i18n
        end
      end
    end
  end
end

Liquid::Template.register_tag('I18n_Headers', Jekyll::Polyglot::Liquid::I18nHeadersTag)
Liquid::Template.register_tag('i18n_headers', Jekyll::Polyglot::Liquid::I18nHeadersTag)
