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
          permalink = normalize_permalink(page['permalink'] || page['url'] || '')
          normalized_permalink = strip_lang_prefix(permalink, site.active_lang)
          permalink_lang = page['permalink_lang']
          site_url = resolve_site_url(site)

          lang_to_permalink = build_lang_to_permalink(site, page['page_id'], normalized_permalink)

          canonical_tag(site, site_url, lang_to_permalink, permalink_lang, normalized_permalink) +
            hreflang_tags(site, site_url, lang_to_permalink, permalink_lang, normalized_permalink)
        end

        private

        def normalize_permalink(permalink)
          permalink.start_with?('/') ? permalink : "/#{permalink}"
        end

        def strip_lang_prefix(permalink, active_lang)
          stripped = permalink.delete_prefix("/#{active_lang}/")
          stripped.start_with?('/') ? stripped : "/#{stripped}"
        end

        def resolve_site_url(site)
          return @url unless @url.empty?

          baseurl = site.config['baseurl'] || ''
          site.config['url'] + baseurl
        end

        def build_lang_to_permalink(site, page_id, normalized_permalink)
          site.find_translations(page_id, normalized_permalink)
        end

        def lookup_permalink(lang_to_permalink, permalink_lang, lang)
          lang_to_permalink[lang] || (permalink_lang && permalink_lang[lang])
        end

        def with_lang_prefix(permalink, lang)
          permalink.start_with?("/#{lang}/") ? permalink : "/#{lang}#{permalink}"
        end

        def canonical_tag(site, site_url, lang_to_permalink, permalink_lang, normalized_permalink)
          current_lang = site.active_lang
          has_translation = lookup_permalink(lang_to_permalink, permalink_lang, current_lang)
          use_default = site.fallback_canonical_to_default_lang && !has_translation && current_lang != site.default_lang

          canonical = if use_default
            normalize_permalink(lookup_permalink(lang_to_permalink, permalink_lang, site.default_lang) || normalized_permalink)
          elsif current_lang == site.default_lang
            normalize_permalink(lookup_permalink(lang_to_permalink, permalink_lang, current_lang) || normalized_permalink)
          else
            current = normalize_permalink(lookup_permalink(lang_to_permalink, permalink_lang, current_lang) || normalized_permalink)
            with_lang_prefix(current, current_lang)
          end
          "<link rel=\"canonical\" href=\"#{site_url}#{canonical}\"/>\n"
        end

        def hreflang_tags(site, site_url, lang_to_permalink, permalink_lang, normalized_permalink)
          default_permalink = normalize_permalink(lookup_permalink(lang_to_permalink, permalink_lang, site.default_lang) || normalized_permalink)

          site.languages.map do |lang|
            has_translation = lookup_permalink(lang_to_permalink, permalink_lang, lang)
            next nil if !has_translation && lang != site.default_lang

            alt = normalize_permalink(lookup_permalink(lang_to_permalink, permalink_lang, lang) || normalized_permalink)
            if lang == site.default_lang
              "<link rel=\"alternate\" hreflang=\"#{lang}\" href=\"#{site_url}#{alt}\"/>\n" \
                "<link rel=\"alternate\" hreflang=\"x-default\" href=\"#{site_url}#{default_permalink}\"/>\n"
            else
              "<link rel=\"alternate\" hreflang=\"#{lang}\" href=\"#{site_url}#{with_lang_prefix(alt, lang)}\"/>\n"
            end
          end.compact.join
        end
      end
    end
  end
end

Liquid::Template.register_tag('I18n_Headers', Jekyll::Polyglot::Liquid::I18nHeadersTag)
Liquid::Template.register_tag('i18n_headers', Jekyll::Polyglot::Liquid::I18nHeadersTag)
