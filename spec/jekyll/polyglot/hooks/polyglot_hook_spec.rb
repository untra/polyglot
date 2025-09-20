require 'jekyll'
require 'rspec/helper'

describe 'Polyglot Custom Hook' do
  before do
    @config = Jekyll::Configuration::DEFAULTS.dup
    @langs = ['en', 'es', 'fr']
    @default_lang = 'en'
    @exclude_from_localization = ['javascript/', 'images/', 'css/']
    @config['languages'] = @langs
    @config['default_lang'] = @default_lang
    @config['exclude_from_localization'] = @exclude_from_localization
    @config['source'] = File.expand_path('../../fixture', __dir__)
    @config['destination'] = File.join(@config['source'], '_site')

    @site = Site.new(@config)
    @site.prepare
  end

  describe ':polyglot, :post_write hook' do
    it 'should trigger the hook with site parameter' do
      hook_triggered = false
      received_site = nil

      # Register the hook
      Jekyll::Hooks.register :polyglot, :post_write do |site|
        hook_triggered = true
        received_site = site
      end

      # Process the site to trigger the hook
      @site.process

      # Verify the hook was triggered and received the site parameter
      expect(hook_triggered).to be true
      expect(received_site).to eq(@site)
      expect(received_site).to be_a(Site)
    end

    it 'should trigger the hook with correct site properties' do
      hook_triggered = false
      received_site = nil

      # Register the hook
      Jekyll::Hooks.register :polyglot, :post_write do |site|
        hook_triggered = true
        received_site = site
      end

      # Process the site to trigger the hook
      @site.process

      # Verify the hook was triggered and site has expected properties
      expect(hook_triggered).to be true
      expect(received_site).to eq(@site)
      expect(received_site.default_lang).to eq(@default_lang)
      expect(received_site.languages).to eq(@langs)
      expect(received_site.active_lang).to eq(@default_lang)
    end

    it 'should allow multiple hooks to be registered' do
      hook1_triggered = false
      hook2_triggered = false
      received_sites = []

      # Register multiple hooks
      Jekyll::Hooks.register :polyglot, :post_write do |site|
        hook1_triggered = true
        received_sites << site
      end

      Jekyll::Hooks.register :polyglot, :post_write do |site|
        hook2_triggered = true
        received_sites << site
      end

      # Process the site to trigger the hooks
      @site.process

      # Verify both hooks were triggered
      expect(hook1_triggered).to be true
      expect(hook2_triggered).to be true
      expect(received_sites.length).to eq(2)
      expect(received_sites.all? { |site| site == @site }).to be true
    end

    it 'should trigger hook after all language processing is complete' do
      hook_triggered = false

      # Register a hook that tracks when it's called
      Jekyll::Hooks.register :polyglot, :post_write do |_site|
        hook_triggered = true
      end

      # Process the site
      @site.process

      # Verify hook was triggered
      expect(hook_triggered).to be true
    end
  end
end
