include Process
module Jekyll
  class Site
    attr_reader :default_lang, :languages, :exclude_from_localization
    attr_accessor :file_langs, :active_lang

    def prepare
      @file_langs = {}
      @default_lang = config.fetch('default_lang', 'en')
      @languages = config.fetch('languages', ['en'])
      @parallel_localization = config.fetch('parallel_localization', true)
      (@keep_files << @languages - [@default_lang]).flatten!
      @exclude_from_localization = config.fetch('exclude_from_localization', [])
      @active_lang = @default_lang
    end

    alias_method :process_orig, :process
    def process
      prepare
      if @parallel_localization
        pids = {}
        @languages.each do |lang|
          pids[lang] = fork do
            process_language lang
          end
        end
        Signal.trap('INT') do
          @languages.each do |lang|
            puts "Killing #{pids[lang]} : #{lang}"
            kill('INT', pids[lang])
          end
        end
        @languages.each do |lang|
          waitpid pids[lang]
          detach pids[lang]
        end
      else
        @languages.each do |lang|
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
      payload
    end

    def process_language(lang)
      @active_lang = lang
      config['active_lang'] = @active_lang
      return process_orig if @active_lang == @default_lang
      process_active_language
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

    # assigns natural permalinks to documents and prioritizes documents with
    # active_lang languages over others
    def coordinate_documents(docs)
      regex = document_url_regex
      approved = {}
      docs.each do |doc|
        lang = doc.data['lang'] || @default_lang
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
      docs.each do |doc|
        relativize_urls doc
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
    # avoids matching excluded files
    def relative_url_regex
      regex = ''
      @exclude.each do |x|
        regex += "(?!#{x}\/)"
      end
      url_quoted = config['url']
      url_quoted = Regexp.quote(url_quoted) unless url_quoted.nil?
      %r{href=\"(?:#{url_quoted})?#{@baseurl}\/((?:#{regex}[^,'\"\s\/?\.#]+\.?)*(?:\/[^\]\[\)\(\"\'\s]*)?)\"}
    end

    def relativize_urls(doc)
      return if @active_lang == @default_lang
      doc.output.gsub!(relative_url_regex, "href=\"#{@baseurl}/#{@active_lang}/" + '\1"')
    end
  end
end
