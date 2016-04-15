# Jekyll Polyglot v1.2.0
# Fast, painless, open source i18n plugin for Jekyll 3.0 Blogs.
#   author: Samuel Volin (@untra)
#   github: https://github.com/untra/polyglot
#   license: MIT
include Process
module Jekyll
  # Alteration to Jekyll Site class
  # provides aliased methods to direct site.write to output into seperate
  # language folders
  class Site
    attr_reader :default_lang, :languages, :exclude_from_localization
    attr_accessor :file_langs, :active_lang

    def prepare
      @file_langs = {}
      @default_lang = config['default_lang'] || 'en'
      @languages = config['languages'] || ['en']
      @parallel_localization = config['parallel_localization'] || true
      (@keep_files << @languages - [@default_lang]).flatten!
      @exclude_from_localization = config['exclude_from_localization'] || []
      @active_lang = @default_lang
    end

    alias_method :process_orig, :process
    def process
      prepare
      if @parallel_localization
        pids = {}
        languages.each do |lang|
          pids[lang] = fork do
            process_language lang
          end
        end
        Signal.trap('INT') do
          languages.each do |lang|
            puts "Killing #{pids[lang]} : #{lang}"
            kill('INT', pids[lang])
          end
        end
        languages.each do |lang|
          waitpid pids[lang]
          detach pids[lang]
        end
      else
        languages.each do |lang|
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
      @dest = @dest + '/' + @active_lang
      @exclude += @exclude_from_localization
      process_orig
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
    def relative_url_regex
      regex = ''
      @exclude.each do |x|
        regex += "(?!#{x}\/)"
      end
      # regex that looks for all relative urls except for excluded files
      %r{href=\"#{@baseurl}\/((?:#{regex}[^,'\"\s\/?\.#-]+\.?)*(?:\/[^\]\[\)\(\"\'\s]*)?)\"}
    end

    def relativize_urls(doc)
      return if @active_lang == @default_lang
      doc.output.gsub!(relative_url_regex, "href=\"#{@baseurl}/#{@active_lang}/" + '\1"')
    end

    # hook to coordinate blog posts and pages into distinct urls,
    # and remove duplicate multilanguage posts and pages
    Jekyll::Hooks.register :site, :post_read do |site|
      site.posts.docs = site.coordinate_documents(site.posts.docs)
      site.pages = site.coordinate_documents(site.pages)
    end

    # hook to coordinate blog posts and pages into distinct urls,
    # and remove duplicate multilanguage posts and pages
    Jekyll::Hooks.register :site, :post_render do |site|
      site.process_documents(site.posts.docs)
      site.process_documents(site.pages)
    end
  end

  # Alteration to Jekyll StaticFile
  # provides aliased methods to direct write to skip files
  # excluded from localization
  class StaticFile
    alias_method :write_orig, :write
    def write(dest)
      return false if exclude_from_localization?
      write_orig(dest)
    end

    def exclude_from_localization?
      return false if @site.active_lang == @site.default_lang
      @site.exclude_from_localization.each do |e|
        return true if relative_path[1..-1].start_with?(e)
      end
      false
    end
  end
end
