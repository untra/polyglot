include Process
module Jekyll
  class Site
    attr_reader :default_lang, :languages, :exclude_from_localization, :lang_vars
    attr_accessor :file_langs, :active_lang

    def prepare
      @file_langs = {}
      fetch_languages
      @parallel_localization = config.fetch('parallel_localization', true)
      @lang_from_path = config.fetch('lang_from_path', false)
      @exclude_from_localization = config.fetch('exclude_from_localization', []).map do |e|
        if File.directory?(e) and e[-1] != '/'
          e + '/'
        else
          e
        end
      end

    end

    def fetch_languages
      @default_lang = config.fetch('default_lang', 'en')
      @languages = config.fetch('languages', ['en'])
      @keep_files += (@languages - [@default_lang])
      @active_lang = @default_lang
      @lang_vars = config.fetch('lang_vars', [])
    end

    alias_method :process_orig, :process
    def process
      prepare
      all_langs = (@languages + [@default_lang]).uniq
      if @parallel_localization
        pids = {}
        all_langs.each do |lang|
          pids[lang] = fork do
            process_language lang
          end
        end
        Signal.trap('INT') do
          all_langs.each do |lang|
            puts "Killing #{pids[lang]} : #{lang}"
            kill('INT', pids[lang])
          end
        end
        all_langs.each do |lang|
          waitpid pids[lang]
          detach pids[lang]
        end
      else
        all_langs.each do |lang|
          process_language lang
        end
      end
    end

    alias_method :site_payload_orig, :site_payload
    def site_payload
      payload = site_payload_orig
      payload['site']['default_lang'] = default_lang
      payload['site']['languages'] = languages
      payload['site']['active_lang'] = active_lang
      lang_vars.each do |v|
        payload['site'][v] = active_lang
      end
      payload
    end

    def process_language(lang)
      @active_lang = lang
      config['active_lang'] = @active_lang
      lang_vars.each do |v|
        config[v] = @active_lang
      end
      if @active_lang == @default_lang
      then process_default_language
      else process_active_language
      end
    end

    def process_default_language
      old_include = @include
      process_orig
      @include = old_include
    end

    def process_active_language
      old_dest = @dest
      old_exclude = @exclude
      @file_langs = {}
      @dest = @dest + '/' + @active_lang
      @exclude += @exclude_from_localization
      process_orig
      @dest = old_dest
      @exclude = old_exclude
    end

    def derive_lang_from_path(doc)
      if !@lang_from_path
        return nil
      end
      segments = doc.relative_path.split('/')
      if doc.relative_path[0] == '_' \
        and segments.length > 2 \
        and segments[1] =~ /^[a-z]{2,3}(:?[_-](:?[A-Za-z]{2}){1,2}){0,2}$/
        return segments[1]
      elsif segments.length > 1 \
        and segments[0] =~ /^[a-z]{2,3}(:?[_-](:?[A-Za-z]{2}){1,2}){0,2}$/
        return segments[0]
      else
        return nil
      end
    end

    # assigns natural permalinks to documents and prioritizes documents with
    # active_lang languages over others.  If lang is not set in front matter,
    # then this tries to derive from the path, if the lang_from_path is set.
    # otherwise it will assign the document to the default_lang
    def coordinate_documents(docs)
      regex = document_url_regex
      approved = {}
      docs.each do |doc|
        lang = doc.data['lang'] || derive_lang_from_path(doc) || @default_lang
        url = doc.url.gsub(regex, '/')
        doc.data['permalink'] = url
        next if @file_langs[url] == @active_lang
        next if @file_langs[url] == @default_lang && lang != @active_lang
        approved[url] = doc
        @file_langs[url] = lang
      end
      approved.values
    end

    # performs any necesarry operations on the documents before rendering them
    def process_documents(docs)
      return if @active_lang == @default_lang
      url = config.fetch('url', false)
      rel_regex = relative_url_regex
      abs_regex = absolute_url_regex(url)
      docs.each do |doc|
        relativize_urls(doc, rel_regex)
        if url
        then relativize_absolute_urls(doc, abs_regex, url)
        end
      end
    end

    # a regex that matches urls or permalinks with i18n prefixes or suffixes
    # matches /en/foo , .en/foo , foo.en/ and other simmilar default urls
    # made by jekyll when parsing documents without explicitly set permalinks
    def document_url_regex
      regex = ''
      @languages.each do |lang|
        regex += "([\/\.]#{lang}[\/\.])|"
      end
      regex.chomp! '|'
      %r{#{regex}}
    end

    # a regex that matches relative urls in a html document
    # matches href="baseurl/foo/bar-baz" and others like it
    # avoids matching excluded files.  prepare makes sure
    # that all @exclude dirs have a trailing slash.
    def relative_url_regex
      regex = ''
      (@exclude).each do |x|
        regex += "(?!#{x})"
      end
      (@languages).each do |x|
        regex += "(?!#{x}\/)"
      end
      %r{href=\"?#{@baseurl}\/((?:#{regex}[^,'\"\s\/?\.#]+\.?)*(?:\/[^\]\[\)\(\"\'\s]*)?)\"}
    end

    def absolute_url_regex(url)
      regex = ''
      (@exclude).each do |x|
        regex += "(?!#{x})"
      end
      (@languages).each do |x|
        regex += "(?!#{x}\/)"
      end
      %r{href=\"?#{url}#{@baseurl}\/((?:#{regex}[^,'\"\s\/?\.#]+\.?)*(?:\/[^\]\[\)\(\"\'\s]*)?)\"}
    end

    def relativize_urls(doc, regex)
      return if doc.output.nil?

      doc.output.gsub!(regex, "href=\"#{@baseurl}/#{@active_lang}/" + '\1"')
    end

    def relativize_absolute_urls(doc, regex, url)
      return if doc.output.nil?

      doc.output.gsub!(regex, "href=\"#{url}#{@baseurl}/#{@active_lang}/" + '\1"')
    end
  end
end
