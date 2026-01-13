require 'jekyll'
require 'rspec/helper'
require 'ostruct'
require 'rspec'
require 'tempfile'

describe Site do
  before do
    @config = Jekyll::Configuration::DEFAULTS.dup
    @langs = ['en', 'sp', 'fr', 'de']
    @default_lang = 'en'
    @exclude_from_localization = ['javascript/', 'images/', 'css/', 'readme']
    @config['langs'] = @langs
    @config['default_lang'] = @default_lang
    @config['exclude_from_localization'] = @exclude_from_localization
    @parallel_localization = @config['parallel_localization'] || true

    @site = Site.new(
      Jekyll.configuration(
        'languages'                 => @langs,
        'default_lang'              => @default_lang,
        'exclude_from_localization' => @exclude_from_localization,
        'source'                    => File.expand_path('fixtures', __dir__),
        'url'                       => 'https://test.github.io'
      )
    )
    @site.prepare
    @baseurls = ['/polyglot', '/big-brother', '/bas3url2']
    @urls = ['http://localhost:4000', 'https://test.github.io']
    @document_url_regex = @site.document_url_regex
    @relative_url_regex = @site.relative_url_regex
    # @relativize_absolute_urls = @site.relativize_absolute_urls
    # @relativize_urls = @site.relativize_urls
  end

  describe @document_url_regex do
    it 'must match common default urls made by jekyll' do
      @langs.each do |lang|
        expect(@document_url_regex).to match "/#{lang}/foobar"
        expect(@document_url_regex).to match ".#{lang}/foobar"
        expect(@document_url_regex).to match "foobar.#{lang}/"
      end
    end
    it 'expect not match natural unfortunate urls' do
      expect(@document_url_regex).to_not match 'people/karen/foobar/'
      expect(@document_url_regex).to_not match 'verbs/gasp/foobar'
      expect(@document_url_regex).to_not match 'products/kefr/foobar.html'
      expect(@document_url_regex).to_not match 'properties/beachside/foo'
    end
    it 'expect relativized_urls should handle different output' do
      expected = 'expected'
      collection_test = Jekyll::Collection.new(@site, 'test')
      document = Jekyll::Document.new('about.en.md', site: @site, collection: collection_test)
      document.output = expected
      @site.relativize_urls(document, @relative_url_regex)
      expect(document.output).to eq(expected)

      # strings can be frozen and still relativized
      document.output.freeze
      @site.relativize_urls(document, @relative_url_regex)
      expect(document.output).to eq(expected)
    end
  end

  describe @parallel_localization do
    it 'should default to true if parallel_localization if not set' do
      expect(@parallel_localization).to eq(true)
    end
    it 'should be false if explicitly set' do
      @config['parallel_localization'] = false
      @parallel_localization = @config['parallel_localization']
      expect(@parallel_localization).to eq(false)
    end
  end

  describe @relative_url_regex do
    it 'must match certain strings with any simple baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @relative_url_regex = @site.relative_url_regex
        expect(@relative_url_regex).to match "href=\"#{baseurl}/about/\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/about-the-product/\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/2016/all-new-flavors/\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/words-1-with-2-numbers-34/\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/purchase/product/1234-business\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/#about\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/about/#team\""
      end
    end
    it 'must match with an empty baseurl' do
      @relative_url_regex = @site.relative_url_regex
      expect(@relative_url_regex).to match 'href="/about/"'
      expect(@relative_url_regex).to match 'href="/about-the-product/"'
      expect(@relative_url_regex).to match 'href="/2016/all-new-flavors/"'
      expect(@relative_url_regex).to match 'href="/2016/words-1-with-2-numbers-34/"'
      expect(@relative_url_regex).to match 'href="/"'
      expect(@relative_url_regex).to match 'href="/purchase/product/1234-business"'
      expect(@relative_url_regex).to match 'href="/#about"'
      expect(@relative_url_regex).to match 'href="/about/#team"'
    end
    it 'must not match external urls' do
      @relative_url_regex = @site.relative_url_regex
      expect(@relative_url_regex).to_not match 'href="http://github.com"'
      expect(@relative_url_regex).to_not match 'href="https://talk.jekyllrb.com'
      expect(@relative_url_regex).to_not match 'href="http://google.com"'
      expect(@relative_url_regex).to_not match 'href="https://untra.github.io/polyglot"'
    end
    it 'must not match excluded urls' do
      @site.exclude += @exclude_from_localization
      @relative_url_regex = @site.relative_url_regex
      expect(@relative_url_regex).to_not match 'href="/images/my-vacation-photo.jpg"'
      expect(@relative_url_regex).to_not match 'href="/css/stylesheet.css"'
      expect(@relative_url_regex).to_not match 'href="/readme"'
      expect(@relative_url_regex).to_not match 'href="/javascript/65487-app.js"'
    end
    it 'must not match excluded urls with a set baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @site.exclude += @exclude_from_localization
        @relative_url_regex = @site.relative_url_regex
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/javascript/65487-app.js\""
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/images/my-vacation-photo.jpg\""
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/css/stylesheet.css\""
      end
    end
    it 'must not match localized urls' do
      @relative_url_regex = @site.relative_url_regex
      @langs.each do |lang|
        expect(@relative_url_regex).to_not match "href=\"#{lang}/about/\""
        expect(@relative_url_regex).to_not match "href=\"#{lang}/\""
        expect(@relative_url_regex).to_not match "href=\"#{lang}/purchase/product/1234-business\""
        expect(@relative_url_regex).to_not match "href=\"#{lang}/#about\""
        expect(@relative_url_regex).to_not match "href=\"#{lang}/about/#team\""
      end
    end

    it 'must not match localized urls with a set baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @site.exclude += @exclude_from_localization
        @relative_url_regex = @site.relative_url_regex
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/javascript/65487-app.js\""
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/images/my-vacation-photo.jpg\""
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/css/stylesheet.css\""
      end
    end

    it 'must not match excluded urls with glob patterns' do
      # Test with glob pattern in exclude_from_localization
      @site.config['exclude_from_localization'] = ['*.sublime-workspace', '*.pdf', '.github']
      @site.prepare
      @site.exclude += @site.exclude_from_localization
      @relative_url_regex = @site.relative_url_regex

      # These should NOT match because they match the glob pattern
      expect(@relative_url_regex).to_not match 'href="/my-project.sublime-workspace"'
      expect(@relative_url_regex).to_not match 'href="/another-project.sublime-workspace"'
      expect(@relative_url_regex).to_not match 'href="/menu.pdf"'
      expect(@relative_url_regex).to_not match 'href="https://untra.github.io"'

      # These should still match because they don't match the glob pattern
      expect(@relative_url_regex).to match 'href="/about/"'
      expect(@relative_url_regex).to match 'href="/contact/"'
    end

    it 'must not match excluded urls with glob patterns and baseurl' do
      # Test with glob pattern in exclude_from_localization and baseurl
      @site.config['exclude_from_localization'] = ['*.sublime-workspace']
      @site.prepare
      @site.exclude += @site.exclude_from_localization

      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @relative_url_regex = @site.relative_url_regex

        # These should NOT match because they match the glob pattern
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/my-project.sublime-workspace\""
        expect(@relative_url_regex).to_not match "href=\"#{baseurl}/another-project.sublime-workspace\""

        # These should still match because they don't match the glob pattern
        expect(@relative_url_regex).to match "href=\"#{baseurl}/about/\""
        expect(@relative_url_regex).to match "href=\"#{baseurl}/contact/\""
      end
    end

    it 'disabled relativization must match ferh relative url with baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @urls.each do |url|
          @site.config['url'] = url
          @relative_url_regex = @site.relative_url_regex(true)
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/about/\""
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/about-the-product/\""
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/2016/all-new-flavors/\""
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/words-1-with-2-numbers-34/\""
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/\""
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/purchase/product/1234-business\""
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/#about\""
          expect(@relative_url_regex).to match "ferh=\"#{baseurl}/about/#team\""
        end
      end
    end
  end

  describe @derive_lang_from_path do
    before(:each) do
      config = Jekyll.configuration(
        'site' => @site,
        'languages'                 => ['en', 'es', 'pt-br'], # fr not included
        'default_lang'              => @default_lang,
        'exclude_from_localization' => @exclude_from_localization,
        'source'                    => File.expand_path('fixtures', __dir__),
        'lang_from_path'            => true
      )
      @site = Site.new(config)
      @site.prepare
    end
    it 'should derive lang from any part of the path' do
      collection_en = Jekyll::Collection.new(@site, 'en')
      collection_es = Jekyll::Collection.new(@site, 'es')
      collection_pt_br = Jekyll::Collection.new(@site, 'pt-br')
      collection_wrong = Jekyll::Collection.new(@site, 'wrong')
      specs = {
        'en' => [
          Jekyll::Document.new('about.en.md', site: @site, collection: collection_en),
          Jekyll::Document.new('fr/about.en.md', site: @site, collection: collection_en)
        ],
        'es' => [
          Jekyll::Document.new('pages/es/acercade.es.md', site: @site, collection: collection_es),
          Jekyll::Document.new('french-touch/restaurant/fr/es/acerade.md', site: @site, collection: collection_es)
        ],
        'pt-br' => [
          Jekyll::Document.new('about.pt-br.md', site: @site, collection: collection_pt_br),
          Jekyll::Document.new('international/restaurant/pt-br/sobre.md', site: @site, collection: collection_pt_br)
        ],
        nil => [
          Jekyll::Document.new('apropos.fr.md', site: @site, collection: collection_wrong), # not included in languages
          Jekyll::Document.new('missing/pt-BR/sobre.md', site: @site, collection: collection_wrong), # wrong capitalization,
          Jekyll::Document.new('taken/blues/newspaper.md', site: @site, collection: collection_wrong), # no matches
          Jekyll::Document.new('es-en-pt-br/wordswordswords.html', site: @site, collection: collection_wrong) # wont split
        ]
      }
      specs.each do |lang, docs|
        docs.each do |document|
          expect(@site.lang_from_path).to eq(true)
          derived = @site.derive_lang_from_path document
          expect(derived).to match lang
        end
      end
    end
  end

  describe @absolute_url_regex do
    it 'must match absolute url' do
      @urls.each do |url|
        @site.config['url'] = url
        @site.prepare
        @absolute_url_regex = @site.absolute_url_regex(url)
        expect(@absolute_url_regex).to match "href=\"#{url}/javascript/65487-app.js\""
        expect(@absolute_url_regex).to match "href=\"#{url}/images/my-vacation-photo.jpg\""
        expect(@absolute_url_regex).to match "href=\"#{url}/css/stylesheet.css\""
      end
    end

    it 'must match absolute url' do
      @urls.each do |url|
        @site.config['url'] = url
        @absolute_url_regex = @site.absolute_url_regex(url)
        expect(@absolute_url_regex).to match "href=\"#{url}/javascript/65487-app.js\""
        expect(@absolute_url_regex).to match "href=\"#{url}/images/my-vacation-photo.jpg\""
        expect(@absolute_url_regex).to match "href=\"#{url}/css/stylesheet.css\""
      end
    end

    it 'must not match absolute url for another project' do
      @urls.each do |url|
        @site.config['url'] = url
        @absolute_url_regex = @site.absolute_url_regex(url)
        expect(@absolute_url_regex).to_not match 'href="http://test_github.io/javascript/65487-app.js'
        expect(@absolute_url_regex).to_not match 'href="http://test_github.io/images/my-vacation-photo.jpg'
        expect(@absolute_url_regex).to_not match 'href="http://github.io/css/stylesheet.css'
      end
    end

    it 'must not match whitespaced urls' do
      @urls.each do |url|
        @site.config['url'] = url
        @absolute_url_regex = @site.absolute_url_regex(url)
        expect(@absolute_url_regex).to_not match "href=\" #{url}/javascript/65487-app.js\""
        expect(@absolute_url_regex).to_not match "href=\" #{url}/images/my-vacation-photo.jpg\""
        expect(@absolute_url_regex).to_not match "href=\" #{url}/css/stylesheet.css\" "
      end
    end

    it 'must match absolute url with baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @urls.each do |url|
          @site.config['url'] = url
          @absolute_url_regex = @site.absolute_url_regex(url)
          expect(@absolute_url_regex).to match " href=\"#{url}#{baseurl}/javascript/65487-app.js\""
          expect(@absolute_url_regex).to match " href=\"#{url}#{baseurl}/images/my-vacation-photo.jpg\""
          expect(@absolute_url_regex).to match " href=\"#{url}#{baseurl}/css/stylesheet.css\""
        end
      end
    end

    it 'disabled relativization must match ferh absolute url with baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @urls.each do |url|
          @site.config['url'] = url
          @absolute_url_regex = @site.absolute_url_regex(url, true)
          expect(@absolute_url_regex).to match "ferh=\"#{url}#{baseurl}/javascript/65487-app.js\""
          expect(@absolute_url_regex).to match "ferh=\"#{url}#{baseurl}/images/my-vacation-photo.jpg\""
          expect(@absolute_url_regex).to match "ferh=\"#{url}#{baseurl}/css/stylesheet.css\""
        end
      end
    end

    it 'negative lookbehind for hreflang, which god help me if this severely hampers performance' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @urls.each do |url|
          @site.config['url'] = url
          @absolute_url_regex = @site.absolute_url_regex(url)
          expect(@absolute_url_regex).to_not match "<link rel=\"canonical\" href=\"#{url}#{baseurl}/images/my-vacation-photo.jpg\">"
          expect(@absolute_url_regex).to_not match "<link rel=\"alternate\" hreflang=\"#{@default_lang}\" href=\"#{url}#{baseurl}/images/my-vacation-photo.jpg\">"
          expect(@absolute_url_regex).to match "<link rel=\"alternate\" hreflang=\"fr\" href=\"#{url}#{baseurl}/images/my-vacation-photo.jpg\">"
        end
      end
    end
  end

  describe 'site prepare' do
    it 'should copy active_lang to additional variables' do
      @site.config['lang_vars'] = ['locale', 'язык']
      @site.prepare
      @langs.each do |lang|
        @site.active_lang = lang
        expect(@site.site_payload['site']['locale']).to match lang
        expect(@site.site_payload['site']['язык']).to match lang
      end
    end
  end

  describe @site do
    it 'should spawn no more than Etc.nprocessors processes' do
      forks = 0
      allow(Etc).to receive(:nprocessors).and_return(2)
      allow(@site).to receive(:fork) {
                        forks += 1
                        fork { sleep 2 }
                      }
      thr = Thread.new {
        sleep 1
        forks
      }
      @site.process
      expect(thr.value).to eq(Etc.nprocessors)
      expect(forks).to eq((@langs + [@default_lang]).uniq.length)
    end

    describe 'assignPageRedirects' do
      before do
        @collection = Jekyll::Collection.new(@site, 'test')
      end

      it 'should create redirects between all language versions' do
        # Create documents for different languages with the same page_id
        docs = [
          # English (default) version
          Jekyll::Document.new('test.md', site: @site, collection: @collection).tap do |doc|
            doc.data['lang'] = 'en'
            doc.data['page_id'] = 'test-page'
            doc.data['permalink'] = '/a-really-long/permalink/'
          end,
          # Chinese version
          Jekyll::Document.new('test.md', site: @site, collection: @collection).tap do |doc|
            doc.data['lang'] = 'zh-CN'
            doc.data['page_id'] = 'test-page'
            doc.data['permalink'] = '/zh-CN/yi-tiao-chao-chang-de-yong-jiu-lian-jie/permalink/'
          end,
          # French version
          Jekyll::Document.new('test.md', site: @site, collection: @collection).tap do |doc|
            doc.data['lang'] = 'fr'
            doc.data['page_id'] = 'test-page'
            doc.data['permalink'] = '/fr/un-tres-long/permalink/'
          end
        ]

        # Test redirects for each document
        docs.each do |doc|
          @site.assignPageRedirects(doc, docs)
          # Each document should have redirects from all other documents
          other_permalinks = docs.reject { |d| d.data['permalink'] == doc.data['permalink'] }
            .map { |d| d.data['permalink'] }
          expect(doc.data['redirect_from']).to match_array(other_permalinks)
        end
      end

      it 'should handle documents with lang-exclusive setting' do
        # Create documents with lang-exclusive setting
        docs = [
          # English version
          Jekyll::Document.new('test.md', site: @site, collection: @collection).tap do |doc|
            doc.data['lang'] = 'en'
            doc.data['page_id'] = 'test-page'
            doc.data['permalink'] = '/a-really-long/permalink/'
          end,
          # Chinese version with lang-exclusive
          Jekyll::Document.new('test.md', site: @site, collection: @collection).tap do |doc|
            doc.data['lang'] = 'zh-CN'
            doc.data['page_id'] = 'test-page'
            doc.data['permalink'] = '/zh-CN/yi-tiao-chao-chang-de-yong-jiu-lian-jie/permalink/'
            doc.data['lang-exclusive'] = ['zh-CN']
          end
        ]

        # Test redirects for Chinese document
        @site.assignPageRedirects(docs[1], docs)
        expect(docs[1].data['redirect_from']).to include('/a-really-long/permalink/')
      end

      it 'should handle documents without page_id' do
        # Create a document without page_id
        doc = Jekyll::Document.new('test.md', site: @site, collection: @collection)
        doc.data['lang'] = 'en'
        doc.data['permalink'] = '/a-really-long/permalink/'

        # Should not raise error and should not set redirect_from
        expect { @site.assignPageRedirects(doc, [doc]) }.not_to raise_error
        expect(doc.data['redirect_from']).to be_nil
      end

      it 'should handle documents with derived language from path' do
        # Create documents with language derived from path
        docs = [
          # English version
          Jekyll::Document.new('test.md', site: @site, collection: @collection).tap do |doc|
            doc.data['page_id'] = 'test-page'
            doc.data['permalink'] = '/a-really-long/permalink/'
          end,
          # Chinese version with language in path
          Jekyll::Document.new('zh-CN/test.md', site: @site, collection: @collection).tap do |doc|
            doc.data['page_id'] = 'test-page'
            doc.data['permalink'] = '/zh-CN/yi-tiao-chao-chang-de-yong-jiu-lian-jie/permalink/'
          end
        ]

        # Enable lang_from_path
        @site.config['lang_from_path'] = true

        # Test redirects for Chinese document
        @site.assignPageRedirects(docs[1], docs)
        expect(docs[1].data['redirect_from']).to include('/a-really-long/permalink/')
      end
    end

    it 'parses static_href block and outputs correct HTML' do
      @site.active_lang = 'en'
      template = <<~LIQUID
        <meta http-equiv="Content-Language" content="{{ site.active_lang }}">
        <link rel="alternate" hreflang="x-default" {% static_href %}href="https://test.github.io/"{% endstatic_href %} />
        <link rel="alternate" hreflang="en" {% static_href %}href="https://test.github.io/"{% endstatic_href %} />
        <link rel="alternate" hreflang="de" {% static_href %}href="https://test.github.io/de"{% endstatic_href %} />
        <link rel="alternate" hreflang="es" {% static_href %}href="https://test.github.io/es"{% endstatic_href %} />
        <link rel="alternate" hreflang="pt-BR" {% static_href %}href="https://test.github.io/pt-BR"{% endstatic_href %} />
      LIQUID
      expected = <<~HTML
        <meta http-equiv="Content-Language" content="en">
        <link rel="alternate" hreflang="x-default" href="https://test.github.io/" />
        <link rel="alternate" hreflang="en" href="https://test.github.io/" />
        <link rel="alternate" hreflang="de" href="https://test.github.io/de" />
        <link rel="alternate" hreflang="es" href="https://test.github.io/es" />
        <link rel="alternate" hreflang="pt-BR" href="https://test.github.io/pt-BR" />
      HTML
      output = @site.liquid_renderer.file("").parse(template).render!(@site.site_payload, registers: { site: @site })
      url = 'https://test.github.io'
      non_abs_regex = @site.absolute_url_regex(url, true)
      file = Tempfile.new(['test', '.md'])
      file.write(output)
      file.rewind
      collection = Jekyll::Collection.new(@site, 'test')
      document = Jekyll::Document.new('test.md', site: @site, collection: collection).tap do |doc|
        doc.data['lang'] = 'en'
        doc.data['page_id'] = 'test-page'
        doc.data['permalink'] = '/a-really-long/permalink/'
        doc.output = output
      end
      corrected = @site.correct_nonrelativized_absolute_urls(document, non_abs_regex, url)
      if corrected != expected
        puts "output: #{output}"
        puts "expected: #{expected}"
        puts "corrected: #{corrected}"
      end
      expect(corrected.gsub(/\s+/, " ").strip).to eq(expected.gsub(/\s+/, " ").strip)
    end

    it 'parses static_href page_id associated hrefs correctly' do
      # Set up the documents with the provided frontmatters
      docs = [
        {
          lang: 'en',
          permalink: '/a-really-long/permalink/',
          title: 'A really long permalink',
          description: 'this page demonstrates'
        },
        {
          lang: 'pt-BR',
          permalink: '/um-longo/permalink/',
          title: 'Um permalink bem longo',
          description: 'esta página demonstra'
        },
        {
          lang: 'nl',
          permalink: '/een-hele-lange/permalink/',
          title: 'Een werkelijk lange permalink',
          description: 'deze pagina demonstreert'
        },
        {
          lang: 'zh-CN',
          permalink: '/yi-tiao-chao-chang-de-yong-jiu-lian-jie/permalink/',
          title: '一条超长的永久链接',
          description: '本页面演示了如何使用'
        }
      ]

      collection = Jekyll::Collection.new(@site, 'test')
      documents = docs.map do |attrs|
        Jekyll::Document.new('test.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = attrs[:title]
          doc.data['permalink'] = attrs[:permalink]
          doc.data['lang'] = attrs[:lang]
          doc.data['page_id'] = 'complex-permalink'
          doc.data['description'] = attrs[:description]
        end
      end

      url = 'https://test.github.io'

      # Simulate the template that outputs alternate links for each doc
      template = <<~LIQUID
        {% for doc in docs %}
        <link rel="alternate" hreflang="{{ doc.lang }}" {% static_href %}href="https://test.github.io{{ doc.permalink }}"{% endstatic_href %} />
        {% endfor %}
      LIQUID

      # Render the template with the documents as context
      payload = @site.site_payload.merge('docs' => documents.map(&:data))
      output = @site.liquid_renderer.file("").parse(template).render!(payload, registers: { site: @site })

      non_abs_regex = @site.absolute_url_regex(url, true)

      # For each document, run correct_nonrelativized_absolute_urls
      documents.each do |doc|
        doc.output = output
        @site.correct_nonrelativized_absolute_urls(doc, non_abs_regex, url)
      end

      # Build the expected HTML
      expected = docs.map do |attrs|
        %{<link rel="alternate" hreflang="#{attrs[:lang]}" href="#{url}#{attrs[:permalink]}" />}
      end.join("\n")

      # Compare the output of the first document (all docs have the same output)
      corrected_output = documents.first.output
      expect(corrected_output.gsub(/\s+/, " ").strip).to eq(expected.gsub(/\s+/, " ").strip)
    end

    it 'i18n_headers defaults custom permalink urls with site baseurl' do
      # Set up site config with baseurl
      @site.config['baseurl'] = '/mysite'
      @site.config['url'] = 'https://test.github.io'
      @site.prepare

      # Create a document with a page_id and custom permalinks for two languages
      collection = Jekyll::Collection.new(@site, 'test')
      docs = [
        Jekyll::Document.new('test.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'A really long permalink'
          doc.data['permalink'] = '/a-really-long/permalink/'
          doc.data['lang'] = 'en'
          doc.data['page_id'] = 'complex-permalink'
        end,
        Jekyll::Document.new('test.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Een werkelijk lange permalink'
          doc.data['permalink'] = 'een-hele-lange/permalink/'
          doc.data['lang'] = 'de'
          doc.data['page_id'] = 'complex-permalink'
        end
      ]
      # Add the collection to the site!
      @site.collections['test'] = collection
      # Add the docs to the collection
      collection.docs.concat(docs)

      # Simulate a page context for the English doc
      page = docs[0].data.merge('permalink' => docs[0].data['permalink'], 'page_id' => docs[0].data['page_id'])
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # Expect the baseurl to be present in the hrefs
      expect(output).to include('href="https://test.github.io/mysite/a-really-long/permalink/"')
      expect(output).to include('href="https://test.github.io/mysite/de/een-hele-lange/permalink/"')
    end

    it 'i18n_headers uses the default_lang permalink for the default_lang alternate link' do
      @site.config['baseurl'] = '/mysite'
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'de']
      @site.config['default_lang'] = 'en'
      @site.prepare

      collection = Jekyll::Collection.new(@site, 'test')
      docs = [
        Jekyll::Document.new('test.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'A really long permalink'
          doc.data['permalink'] = '/a-really-long/permalink/'
          doc.data['lang'] = 'en'
          doc.data['page_id'] = 'complex-permalink'
        end,
        Jekyll::Document.new('test.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Eine wirklich lange permalink'
          doc.data['permalink'] = '/de/eine-wirklich-lange/permalink/'
          doc.data['lang'] = 'de'
          doc.data['page_id'] = 'complex-permalink'
        end
      ]
      @site.collections['test'] = collection
      collection.docs.concat(docs)

      # Simulate a page context for the English doc
      page = docs[0].data.merge('permalink' => docs[0].data['permalink'], 'page_id' => docs[0].data['page_id'])
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # The default_lang alternate link should use the en permalink
      expect(output).to include('rel="alternate" hreflang="en" href="https://test.github.io/mysite/a-really-long/permalink/"')
      # The de alternate link should use the de permalink
      expect(output).to include('rel="alternate" hreflang="de" href="https://test.github.io/mysite/de/eine-wirklich-lange/permalink/"')
    end

    it 'i18n_headers outputs a canonical link for every language page' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'es', 'fr', 'de', 'sp']
      @site.config['default_lang'] = 'en'
      @site.prepare

      # Define permalinks for each language (some intentionally minimal for edge case)
      permalinks = {
        'en' => '/foo/bar/baz/',
        'es' => '/es/foo/bar/baz/',
        'fr' => '/fr/foo/bar/baz/'
      }

      collection = Jekyll::Collection.new(@site, 'test')
      docs = @site.config['languages'].map do |lang|
        Jekyll::Document.new('test.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = "A page in #{lang}"
          doc.data['permalink'] = permalinks[lang]
          doc.data['lang'] = lang
          doc.data['page_id'] = 'foo-bar-baz'
        end
      end
      @site.collections['test'] = collection
      collection.docs.concat(docs)

      # For each language, simulate the page context and check canonical
      @site.config['languages'].each do |lang|
        @site.active_lang = lang
        page = docs.find { |d| d.data['lang'] == lang }.data.merge('permalink' => permalinks[lang], 'page_id' => 'foo-bar-baz')
        context = Liquid::Context.new({}, {}, { site: @site, page: page })
        template = "{% i18n_headers %}"
        output = Liquid::Template.parse(template).render(context)
        # Check that a canonical link is present and not empty
        expect(output).to match(%r{<link rel="canonical" href="https://test\.github\.io[^"]*"\s*/>})
      end
    end

    it 'i18n_headers x-default hreflang points to default language version' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://www.example.com'
      @site.config['languages'] = ['en', 'de', 'es', 'pt-BR']
      @site.config['default_lang'] = 'en'
      @site.prepare

      # Create documents with different permalinks for each language
      collection = Jekyll::Collection.new(@site, 'test')
      docs = [
        Jekyll::Document.new('accessibility.en.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Accessibility'
          doc.data['permalink'] = '/accessibility'
          doc.data['lang'] = 'en'
          doc.data['page_id'] = 'accessibility'
        end,
        Jekyll::Document.new('accessibility.de.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Barrierefreiheit'
          doc.data['permalink'] = '/de/accessibility'
          doc.data['lang'] = 'de'
          doc.data['page_id'] = 'accessibility'
        end,
        Jekyll::Document.new('accessibility.es.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Accesibilidad'
          doc.data['permalink'] = '/es/accessibility'
          doc.data['lang'] = 'es'
          doc.data['page_id'] = 'accessibility'
        end,
        Jekyll::Document.new('accessibility.pt-BR.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Acessibilidade'
          doc.data['permalink'] = '/pt-BR/accessibility'
          doc.data['lang'] = 'pt-BR'
          doc.data['page_id'] = 'accessibility'
        end
      ]
      @site.collections['test'] = collection
      collection.docs.concat(docs)

      # Test from German page perspective
      @site.active_lang = 'de'
      page = docs.find { |d| d.data['lang'] == 'de' }.data.merge('page_id' => 'accessibility')
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # x-default should point to the English (default) version, not the German version
      expect(output).to include('hreflang="x-default" href="https://www.example.com/accessibility"')
      expect(output).to include('hreflang="en" href="https://www.example.com/accessibility"')
      expect(output).to include('hreflang="de" href="https://www.example.com/de/accessibility"')
      expect(output).to include('hreflang="es" href="https://www.example.com/es/accessibility"')
      expect(output).to include('hreflang="pt-BR" href="https://www.example.com/pt-BR/accessibility"')
      expect(output).to_not include('hreflang="en" ferh="https://www.example.com/accessibility"')
    end

    it 'i18n_headers x-default always points to default language regardless of current page language' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://www.discourse.org'
      @site.config['languages'] = ['en', 'de', 'es', 'pt-BR']
      @site.config['default_lang'] = 'en'
      @site.prepare

      # Create documents with different permalinks for each language
      collection = Jekyll::Collection.new(@site, 'test')
      docs = [
        Jekyll::Document.new('accessibility.en.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Accessibility'
          doc.data['permalink'] = '/accessibility'
          doc.data['lang'] = 'en'
          doc.data['page_id'] = 'accessibility'
        end,
        Jekyll::Document.new('accessibility.de.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Barrierefreiheit'
          doc.data['permalink'] = '/de/accessibility'
          doc.data['lang'] = 'de'
          doc.data['page_id'] = 'accessibility'
        end,
        Jekyll::Document.new('accessibility.es.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Accesibilidad'
          doc.data['permalink'] = '/es/accessibility'
          doc.data['lang'] = 'es'
          doc.data['page_id'] = 'accessibility'
        end,
        Jekyll::Document.new('accessibility.pt-BR.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Acessibilidade'
          doc.data['permalink'] = '/pt-BR/accessibility'
          doc.data['lang'] = 'pt-BR'
          doc.data['page_id'] = 'accessibility'
        end
      ]
      @site.collections['test'] = collection
      collection.docs.concat(docs)

      # Test from each language page perspective
      ['en', 'de', 'es', 'pt-BR'].each do |current_lang|
        @site.active_lang = current_lang
        page = docs.find { |d| d.data['lang'] == current_lang }.data.merge('page_id' => 'accessibility')
        context = Liquid::Context.new({}, {}, { site: @site, page: page })
        template = "{% i18n_headers %}"
        output = Liquid::Template.parse(template).render(context)

        # x-default should ALWAYS point to the English (default) version, regardless of current language
        expect(output).to include('hreflang="x-default" href="https://www.discourse.org/accessibility"')

        # The canonical should point to the current language version
        if current_lang == 'en'
          expect(output).to include('rel="canonical" href="https://www.discourse.org/accessibility"')
        else
          expect(output).to include("rel=\"canonical\" href=\"https://www.discourse.org/#{current_lang}/accessibility\"")
        end
      end
    end

    it 'i18n_headers works with posts that use inferred permalinks from date and slug' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'fr']
      @site.config['default_lang'] = 'en'
      @site.prepare

      # Simulate two posts in different languages, no explicit permalink
      post_date = Time.new(2024, 6, 1)
      collection = Jekyll::Collection.new(@site, 'posts')
      posts = [
        Jekyll::Document.new('2024-06-01-my-inferred-post.en.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'post'
          doc.data['title'] = 'My Inferred Post'
          doc.data['lang'] = 'en'
          doc.data['page_id'] = 'my-inferred-post'
          doc.data['date'] = post_date
          # No explicit permalink
          doc.data['url'] = '/2024/06/01/my-inferred-post/' # Simulate Jekyll's .url
        end,
        Jekyll::Document.new('2024-06-01-my-inferred-post.fr.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'post'
          doc.data['title'] = 'Mon Article Inféré'
          doc.data['lang'] = 'fr'
          doc.data['page_id'] = 'my-inferred-post'
          doc.data['date'] = post_date
          # No explicit permalink
          doc.data['url'] = '/2024/06/01/my-inferred-post/' # Simulate Jekyll's .url
        end
      ]
      @site.collections['posts'] = collection
      collection.docs.concat(posts)

      # Use the url field as the expected permalink
      inferred_permalink = "/2024/06/01/my-inferred-post/"

      # Simulate the page context for the English post
      page = posts[0].data.merge('page_id' => 'my-inferred-post')
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # Canonical should be for the current language
      expect(output).to include(%{<link rel="canonical" href="https://test.github.io#{inferred_permalink}"/>})
      # Alternate for English (default)
      expect(output).to include(%{<link rel="alternate" hreflang="en" href="https://test.github.io#{inferred_permalink}"/>})
      # Alternate for French (should be /fr/ prefix)
      expect(output).to include(%{<link rel="alternate" hreflang="fr" href="https://test.github.io/fr#{inferred_permalink}"/>})
    end

    it 'i18n_headers omits hreflang for languages without translations when hreflang_fallback is false' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'es', 'fr', 'de']
      @site.config['default_lang'] = 'en'
      @site.config['hreflang_fallback'] = false
      @site.prepare

      # Create a page that only has English and Spanish translations (no French or German)
      collection = Jekyll::Collection.new(@site, 'test')
      docs = [
        Jekyll::Document.new('about.en.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'About Us'
          doc.data['permalink'] = '/about/'
          doc.data['lang'] = 'en'
          doc.data['page_id'] = 'about'
        end,
        Jekyll::Document.new('about.es.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'Sobre Nosotros'
          doc.data['permalink'] = '/es/sobre-nosotros/'
          doc.data['lang'] = 'es'
          doc.data['page_id'] = 'about'
        end
      ]
      @site.collections['test'] = collection
      collection.docs.concat(docs)

      # Simulate the page context for the English doc
      page = docs[0].data.merge('permalink' => '/about/', 'page_id' => 'about')
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # Should include hreflang for English (default language, always included)
      expect(output).to include('hreflang="en"')
      # Should include hreflang for Spanish (has translation)
      expect(output).to include('hreflang="es"')
      # Should NOT include hreflang for French (no translation, fallback disabled)
      expect(output).to_not include('hreflang="fr"')
      # Should NOT include hreflang for German (no translation, fallback disabled)
      expect(output).to_not include('hreflang="de"')
      # Should still include x-default
      expect(output).to include('hreflang="x-default"')
    end

    it 'i18n_headers includes all hreflang when hreflang_fallback is true (default)' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'es', 'fr', 'de']
      @site.config['default_lang'] = 'en'
      @site.config['hreflang_fallback'] = true
      @site.prepare

      # Create a page that only has English translation
      collection = Jekyll::Collection.new(@site, 'test')
      docs = [
        Jekyll::Document.new('about.en.md', site: @site, collection: collection).tap do |doc|
          doc.data['layout'] = 'page'
          doc.data['title'] = 'About Us'
          doc.data['permalink'] = '/about/'
          doc.data['lang'] = 'en'
          doc.data['page_id'] = 'about'
        end
      ]
      @site.collections['test'] = collection
      collection.docs.concat(docs)

      # Simulate the page context for the English doc
      page = docs[0].data.merge('permalink' => '/about/', 'page_id' => 'about')
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # Should include hreflang for ALL languages (fallback enabled)
      expect(output).to include('hreflang="en"')
      expect(output).to include('hreflang="es"')
      expect(output).to include('hreflang="fr"')
      expect(output).to include('hreflang="de"')
      expect(output).to include('hreflang="x-default"')
    end

    it 'hreflang_fallback defaults to true when not specified' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'fr']
      @site.config['default_lang'] = 'en'
      @site.config.delete('hreflang_fallback')
      @site.prepare

      expect(@site.hreflang_fallback).to eq(true)
    end

    it 'i18n_headers omits hreflang for standalone pages without translations when hreflang_fallback is false' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'es', 'fr', 'de']
      @site.config['default_lang'] = 'en'
      @site.config['hreflang_fallback'] = false
      @site.prepare

      # Create standalone pages (not in collections) with page_id - only English and Spanish translations
      # Using OpenStruct to simulate Jekyll::Page objects with data hash
      page_en = OpenStruct.new(
        data: {
          'layout' => 'page',
          'title' => 'About Us',
          'permalink' => '/about/',
          'lang' => 'en',
          'page_id' => 'about-page'
        }
      )
      page_es = OpenStruct.new(
        data: {
          'layout' => 'page',
          'title' => 'Sobre Nosotros',
          'permalink' => '/es/sobre-nosotros/',
          'lang' => 'es',
          'page_id' => 'about-page'
        }
      )

      # Add pages to site.pages (not to collections)
      @site.pages << page_en
      @site.pages << page_es

      # Simulate the page context for the English page
      page = page_en.data.merge('permalink' => '/about/', 'page_id' => 'about-page')
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # Should include hreflang for English (default language, always included)
      expect(output).to include('hreflang="en"')
      # Should include hreflang for Spanish (has translation via standalone page)
      expect(output).to include('hreflang="es"')
      # Should NOT include hreflang for French (no translation, fallback disabled)
      expect(output).to_not include('hreflang="fr"')
      # Should NOT include hreflang for German (no translation, fallback disabled)
      expect(output).to_not include('hreflang="de"')
      # Should still include x-default
      expect(output).to include('hreflang="x-default"')
    end

    it 'i18n_headers finds translations by matching permalink when no page_id is set' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'es', 'fr', 'de']
      @site.config['default_lang'] = 'en'
      @site.config['hreflang_fallback'] = false
      @site.prepare

      # Create standalone pages with same permalink but NO page_id - only lang differs
      # This is a common pattern: same permalink, different lang frontmatter
      page_en = OpenStruct.new(
        data: {
          'layout' => 'page',
          'title' => 'About Us',
          'permalink' => '/about/',
          'lang' => 'en'
          # No page_id!
        }
      )
      page_es = OpenStruct.new(
        data: {
          'layout' => 'page',
          'title' => 'Sobre Nosotros',
          'permalink' => '/about/',  # Same permalink as English
          'lang' => 'es'
          # No page_id!
        }
      )

      # Add pages to site.pages
      @site.pages << page_en
      @site.pages << page_es

      # Simulate the page context for the English page
      page = page_en.data.merge('permalink' => '/about/')
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # Should include hreflang for English (default language, always included)
      expect(output).to include('hreflang="en"')
      # Should include hreflang for Spanish (has translation via same permalink)
      expect(output).to include('hreflang="es"')
      # Should NOT include hreflang for French (no translation, fallback disabled)
      expect(output).to_not include('hreflang="fr"')
      # Should NOT include hreflang for German (no translation, fallback disabled)
      expect(output).to_not include('hreflang="de"')
      # Should still include x-default
      expect(output).to include('hreflang="x-default"')
    end

    it 'i18n_headers treats pages without lang frontmatter as default language' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'es', 'fr', 'de']
      @site.config['default_lang'] = 'en'
      @site.config['hreflang_fallback'] = false
      @site.prepare

      # Create a single page WITHOUT lang frontmatter (common real-world case)
      # This page should only have English hreflang, not all languages
      page_no_lang = OpenStruct.new(
        data: {
          'layout' => 'page',
          'title' => 'About Us',
          'permalink' => '/about/'
          # No lang! This is the key case
        }
      )

      # Add page to site.pages
      @site.pages << page_no_lang

      # Simulate the page context
      page = page_no_lang.data.merge('permalink' => '/about/')
      context = Liquid::Context.new({}, {}, { site: @site, page: page })
      template = "{% i18n_headers %}"
      output = Liquid::Template.parse(template).render(context)

      # Should include hreflang for English (default language, page assumed to be English)
      expect(output).to include('hreflang="en"')
      # Should NOT include hreflang for Spanish (no translation, fallback disabled)
      expect(output).to_not include('hreflang="es"')
      # Should NOT include hreflang for French (no translation, fallback disabled)
      expect(output).to_not include('hreflang="fr"')
      # Should NOT include hreflang for German (no translation, fallback disabled)
      expect(output).to_not include('hreflang="de"')
      # Should still include x-default
      expect(output).to include('hreflang="x-default"')
    end

    it 'relativize_canonical defaults to false when not specified' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'fr']
      @site.config['default_lang'] = 'en'
      @site.config.delete('relativize_canonical')
      @site.prepare

      expect(@site.relativize_canonical).to eq(false)
    end

    it 'absolute_url_regex does not match canonical URLs by default (relativize_canonical false)' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'fr']
      @site.config['default_lang'] = 'en'
      @site.config['relativize_canonical'] = false
      @site.prepare

      url = 'https://test.github.io'
      @absolute_url_regex = @site.absolute_url_regex(url)

      # Canonical URLs should NOT be matched (negative lookbehind excludes them)
      expect(@absolute_url_regex).to_not match '<link rel="canonical" href="https://test.github.io/about">'
      # But regular hrefs should still be matched
      expect(@absolute_url_regex).to match ' href="https://test.github.io/about"'
    end

    it 'absolute_url_regex matches canonical URLs when relativize_canonical is true' do
      @site.config['baseurl'] = ''
      @site.config['url'] = 'https://test.github.io'
      @site.config['languages'] = ['en', 'fr']
      @site.config['default_lang'] = 'en'
      @site.config['relativize_canonical'] = true
      @site.prepare

      url = 'https://test.github.io'
      @absolute_url_regex = @site.absolute_url_regex(url)

      # Canonical URLs SHOULD be matched when relativize_canonical is true
      expect(@absolute_url_regex).to match '<link rel="canonical" href="https://test.github.io/about">'
      # hreflang URLs should still NOT be matched
      expect(@absolute_url_regex).to_not match '<link rel="alternate" hreflang="en" href="https://test.github.io/about">'
      expect(@absolute_url_regex).to_not match '<link rel="alternate" hreflang="x-default" href="https://test.github.io/about">'
    end
  end
end
