require 'rspec/helper'
require 'ostruct'
require 'fileutils'
require 'tmpdir'
require_relative '../../../../lib/jekyll/polyglot/hooks/coordinate'
Dir.mktmpdir do |_|
  FileUtils.mkdir_p 'css'
  FileUtils.mkdir_p 'images'
  FileUtils.mkdir_p 'javascript'
  describe 'hook_coordinate' do
    before do
      @config = Jekyll::Configuration::DEFAULTS.dup
      @langs = ['en', 'fr', 'es']
      @default_lang = 'en'
      @exclude_from_localization = ['javascript', 'images', 'css/', 'README.md']
      @config['langs'] = @langs
      @config['default_lang'] = @default_lang
      @config['exclude_from_localization'] = @exclude_from_localization
      @parallel_localization = @config['parallel_localization'] || true
      @site = Site.new(
        Jekyll.configuration(
          'languages'                 => @langs,
          'default_lang'              => @default_lang,
          'exclude_from_localization' => @exclude_from_localization,
          'source'                    => File.expand_path('../../../../fixture', __FILE__)
        )
      )
      @site.prepare
      @collection = Jekyll::Collection.new(@site, "fixture")
      @site.data = { 'foo' => 'databar', 'baz' => 'databaz', 'strings' => {
                       'banana' => 'banana',
                     }, }
      @site.data['en'] = { 'foo' => 'enbar', 'strings' => {
                             'apple' => 'apple', 'ice cream' => 'ice cream',
                           }, }
      @site.data['fr'] = { 'foo' => 'frbar', 'strings' => {
                             'ice cream' => 'crème glacée',
                           }, }
      
    end

    it 'should have trailing / on all dir entries in exclude_from_localization' do
      expect(@site.exclude_from_localization).to eq(["javascript/", "images/", "css/", "README.md"])
    end

    it 'should merge the site.data.active_lang to the site.data' do
      hook_coordinate(@site)
      expect(@site.data['foo']).to eq('enbar')
      expect(@site.data['baz']).to eq('databaz')
      expect(@site.data['strings']['ice cream']).to eq('ice cream')
      expect(@site.data['strings']['apple']).to eq('apple')
      expect(@site.data['strings']['banana']).to eq('banana')
    end

    it 'should fall back to the default_lang when using translated site data' do
      @site.active_lang = 'fr'
      hook_coordinate(@site)
      expect(@site.data['foo']).to eq('frbar')
      expect(@site.data['baz']).to eq('databaz')
      expect(@site.data['strings']['ice cream']).to eq('crème glacée') # Populated from @site.data['strings'][@site.active_lang]['ice cream']
      expect(@site.data['strings']['apple']).to eq('apple') # Populated from @site.data['strings'][@site.default_lang]['apple']
      expect(@site.data['strings']['banana']).to eq('banana') # Populated from @site.data['strings']['apple']
    end

    it "site.process triggers :polyglot, :post_write hook" do
      hook_called = false
      Jekyll::Hooks.register(:polyglot, :post_write) do |_site|
        hook_called = true
      end
      @site.process
      expect(hook_called).to be true
    end

    describe @coordinate_documents do
      it 'test fixtures in the default lang' do
        expect(@site.source).to end_with('spec/fixture')
        @site.process_language 'en'
        expect(@site.pages).to have_attributes(size: 2)
      end

      it 'should include files in the default_lang without active_lang' do
        @site.process_language 'fr'
        expect(@site.pages).to have_attributes(size: 3)
        expect(@site.pages.map { |doc| doc.name }).to include('en.about.md')
      end

      it 'should include files in the active_lang' do
        @site.process_language 'fr'
        expect(@site.pages).to have_attributes(size: 3)
        expect(@site.pages.map { |doc| doc.name }).to include('fr.menu.md', 'fr.members.md')
      end

      it 'should not include files in the default_lang with the active_lang' do
        @site.process_language 'fr'
        print @site.pages.map { |doc| doc.name }
        expect(@site.pages.map { |doc| doc.name }).not_to include('en.menu.md')
      end

      it 'should not include files in a different lang from the active_lang' do
        @site.process_language 'fr'
        expect(@site.pages.map { |doc| doc.name }).not_to include('es.menu.md')
      end

      it 'should not be included if the active_lang is not part of the lang-exclusive' do
        @site.process_language 'fr'
        expect(@site.pages.map { |doc| doc.name }).not_to include('es.samba.md')
      end

      it 'should respect permalinks when page_id is specified' do
        @site.process_language 'en'
        expect(@site.pages.select { |doc| doc.name == 'en.about.md' }.first().permalink).to eq('about')
        expect(@site.pages.select { |doc| doc.name == 'en.menu.md' }.first().permalink).to eq('the-menu')
        @site.process_language 'es'
        expect(@site.pages.select { |doc| doc.name == 'es.menu.md' }.first().permalink).to eq('el-menu')
        expect(@site.pages.select { |doc| doc.name == 'es.samba.md' }.first().permalink).to eq('samba')
        @site.process_language 'fr'
        expect(@site.pages.select { |doc| doc.name == 'fr.menu.md' }.first().permalink).to eq('le-menu')
        expect(@site.pages.select { |doc| doc.name == 'fr.members.md' }.first().permalink).to eq('members')
      end
      
      it 'should contain permalink_lang when page_id is specified' do
        @site.process_language 'en'
        menu_permalink_lang = @site.pages.select { |doc| doc.name == 'en.menu.md' }.first().data['permalink_lang']
        expect(menu_permalink_lang).to have_attributes(size: 3)
        expect(menu_permalink_lang.keys).to match_array(@site.config['languages'])
        expect(menu_permalink_lang['en']).to eq('the-menu')
        expect(menu_permalink_lang['es']).to eq('el-menu')
        expect(menu_permalink_lang['fr']).to eq('le-menu')
      end
    end
  end
end
