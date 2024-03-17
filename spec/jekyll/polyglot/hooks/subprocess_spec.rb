require 'rspec/helper'
describe 'site process error handling' do
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
      @site.data['en'] = { 'foo' => 'enbar', 'strings' => {
                             'apple' => 'apple', 'ice cream' => 'ice cream',
                           }, }
      @site.data['fr'] = { 'foo' => 'frbar', 'strings' => {
                             'ice cream' => 'crème glacée',
                           }, }
      
    end
    it "site.process throws FatalError if a subprocess fails" do
      @thistestonly = false
      semaphore = Mutex.new
      Jekyll::Hooks.register(:site, :post_write) do |site|
        
          semaphore.synchronize {
            unless @thistestonly
              @thistestonly = true
              raise 'fail fr intentionally'
            end
          }
        
      end
      expect { @site.process }.to raise_error(RuntimeError)
    end
  end