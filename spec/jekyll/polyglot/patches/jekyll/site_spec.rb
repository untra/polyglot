require 'jekyll'
require 'rspec/helper'
require 'ostruct'
require 'rspec'
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
        'source'                    => File.expand_path('fixtures', __dir__)
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
  end

  # describe @relativize_urls do
  #   it 'does not raise' do
  #     expect(@relativize_urls(@site.Document.new(), @relative_url_regex)).not_to raise_error
  #   end
  # end

  # describe @relativize_absolute_urls do
  #   it 'does not raise' do
  #     expect( @relativize_absolute_urls(@site.Document.new(), @absolute_url_regex)).not_to raise_error
  #   end
  # end
end
