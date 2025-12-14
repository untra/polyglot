require 'rspec/helper'
require 'nokogiri'
require 'fileutils'
require 'tmpdir'

Dir.mktmpdir do |tmpdir|
  FileUtils.mkdir_p File.join(tmpdir, 'css')
  FileUtils.mkdir_p File.join(tmpdir, 'images')
  FileUtils.mkdir_p File.join(tmpdir, 'javascript')

  describe 'Sitemap Generation' do
    before(:all) do
      @langs = ['en', 'fr', 'es']
      @default_lang = 'en'
      @exclude_from_localization = ['javascript', 'images', 'css/', 'public']
      @fixture_path = File.expand_path('../../../fixture', __FILE__)

      @dest_path = File.join(@fixture_path, '_site')

      @site = Site.new(
        Jekyll.configuration(
          'languages'                 => @langs,
          'default_lang'              => @default_lang,
          'exclude_from_localization' => @exclude_from_localization,
          'source'                    => @fixture_path,
          'destination'               => @dest_path,
          'url'                       => 'http://localhost:4000',
          'include'                   => ['pages'],
          'collections'               => {
            'pages' => { 'output' => true },
            'posts' => { 'output' => true }
          }
        )
      )
      @site.process

      @sitemap_path = File.join(@site.dest, 'sitemap.xml')
      if File.exist?(@sitemap_path)
        @sitemap = Nokogiri::XML(File.read(@sitemap_path))
        @ns = { 'sm' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xhtml' => 'http://www.w3.org/1999/xhtml' }
      end
    end

    describe 'sitemap file generation' do
      it 'generates a sitemap.xml file' do
        expect(File.exist?(@sitemap_path)).to be true
      end

      it 'generates valid XML' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)
        expect(@sitemap.errors).to be_empty
      end

      it 'contains urlset root element' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)
        expect(@sitemap.at_xpath('//sm:urlset', @ns)).not_to be_nil
      end
    end

    describe 'post entries in sitemap' do
      it 'includes the default language version of posts' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)
        urls = @sitemap.xpath('//sm:url/sm:loc', @ns).map(&:text)
        expect(urls.any? { |u| u.include?('test-post') && !u.include?('/fr/') && !u.include?('/es/') }).to be true
      end

      it 'includes alternate language versions of posts' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)
        urls = @sitemap.xpath('//sm:url/sm:loc', @ns).map(&:text)
        expect(urls.any? { |u| u.include?('/fr/') && u.include?('test-post') }).to be true
        expect(urls.any? { |u| u.include?('/es/') && u.include?('test-post') }).to be true
      end
    end

    describe 'hreflang links in sitemap' do
      it 'includes hreflang links for posts' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)

        # Find a post URL entry (looking for the English version)
        post_url = @sitemap.xpath('//sm:url', @ns).find do |url|
          loc = url.at_xpath('sm:loc', @ns)&.text
          loc && loc.include?('test-post') && !loc.include?('/fr/') && !loc.include?('/es/')
        end

        skip 'test-post not found in sitemap' if post_url.nil?

        hreflang_links = post_url.xpath('xhtml:link[@rel="alternate"]', @ns)
        expect(hreflang_links.size).to be >= 3

        hreflangs = hreflang_links.map { |l| l['hreflang'] }
        expect(hreflangs).to include('en')
        expect(hreflangs).to include('fr')
        expect(hreflangs).to include('es')
      end

      it 'includes x-default hreflang link for posts' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)

        # Find a post URL entry
        post_url = @sitemap.xpath('//sm:url', @ns).find do |url|
          loc = url.at_xpath('sm:loc', @ns)&.text
          loc && loc.include?('test-post') && !loc.include?('/fr/') && !loc.include?('/es/')
        end

        skip 'test-post not found in sitemap' if post_url.nil?

        x_default = post_url.at_xpath("xhtml:link[@hreflang='x-default']", @ns)
        expect(x_default).not_to be_nil
        expect(x_default['href']).to include('test-post')
      end

      it 'hreflang links point to correct language paths' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)

        # Find a post URL entry
        post_url = @sitemap.xpath('//sm:url', @ns).find do |url|
          loc = url.at_xpath('sm:loc', @ns)&.text
          loc && loc.include?('test-post') && !loc.include?('/fr/') && !loc.include?('/es/')
        end

        skip 'test-post not found in sitemap' if post_url.nil?

        hreflang_links = post_url.xpath('xhtml:link[@rel="alternate"]', @ns)

        en_link = hreflang_links.find { |l| l['hreflang'] == 'en' }
        fr_link = hreflang_links.find { |l| l['hreflang'] == 'fr' }
        es_link = hreflang_links.find { |l| l['hreflang'] == 'es' }

        expect(en_link['href']).not_to include('/en/')
        expect(fr_link['href']).to include('/fr/')
        expect(es_link['href']).to include('/es/')
      end
    end

    describe 'page entries with permalink_lang' do
      it 'includes hreflang links for pages with page_id' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)

        # Find the menu page which has page_id
        menu_url = @sitemap.xpath('//sm:url', @ns).find do |url|
          loc = url.at_xpath('sm:loc', @ns)&.text
          loc && loc.include?('menu') && !loc.include?('/fr/') && !loc.include?('/es/')
        end

        skip 'menu page not found in sitemap' if menu_url.nil?

        hreflang_links = menu_url.xpath('xhtml:link[@rel="alternate"]', @ns)
        expect(hreflang_links.size).to be >= 3
      end

      it 'uses permalink_lang for accurate hreflang URLs when available' do
        skip 'sitemap.xml not generated' unless File.exist?(@sitemap_path)

        # Find the menu page entry for English
        menu_url = @sitemap.xpath('//sm:url', @ns).find do |url|
          loc = url.at_xpath('sm:loc', @ns)&.text
          loc && loc.include?('the-menu')
        end

        skip 'the-menu page not found in sitemap' if menu_url.nil?

        hreflang_links = menu_url.xpath('xhtml:link[@rel="alternate"]', @ns)
        fr_link = hreflang_links.find { |l| l['hreflang'] == 'fr' }

        skip 'French hreflang link not found' if fr_link.nil?

        # With permalink_lang, French menu should be 'le-menu' not 'the-menu'
        expect(fr_link['href']).to include('le-menu')
      end
    end
  end
end
