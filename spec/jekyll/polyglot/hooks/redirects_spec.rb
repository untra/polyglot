require 'rspec/helper'
require 'fileutils'
require 'tmpdir'

describe 'hook_redirects' do
  let(:tmpdir) { Dir.mktmpdir }
  let(:dest_dir) { File.join(tmpdir, '_site') }

  before do
    FileUtils.mkdir_p(dest_dir)
    @config = Jekyll::Configuration::DEFAULTS.dup
    @langs = ['en', 'es', 'fr', 'de']
    @default_lang = 'en'
  end

  after do
    FileUtils.rm_rf(tmpdir)
  end

  def create_site(config_overrides = {})
    site_config = {
      'languages' => @langs,
      'default_lang' => @default_lang,
      'source' => tmpdir,
      'destination' => dest_dir
    }.merge(config_overrides)

    site = Site.new(Jekyll.configuration(site_config))
    site.prepare
    site
  end

  def write_redirects(content)
    File.write(File.join(tmpdir, '_redirects'), content)
  end

  def read_output_redirects
    path = File.join(dest_dir, '_redirects')
    return nil unless File.exist?(path)

    File.read(path)
  end

  describe 'when localize_redirects is disabled (default)' do
    it 'should not modify the _redirects file' do
      write_redirects("/github https://github.com/org/repo 302\n")
      # Copy file to dest to simulate Jekyll build
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to eq("/github https://github.com/org/repo 302\n")
    end
  end

  describe 'when localize_redirects is enabled' do
    it 'should generate localized redirects for each language' do
      write_redirects("/github https://github.com/org/repo 302\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to include("/github https://github.com/org/repo 302")
      expect(output).to include("/es/github https://github.com/org/repo 302")
      expect(output).to include("/fr/github https://github.com/org/repo 302")
      expect(output).to include("/de/github https://github.com/org/repo 302")
      # Should not include default language prefix
      expect(output).not_to include("/en/github")
    end

    it 'should preserve comments' do
      write_redirects("# This is a comment\n/github https://github.com/org/repo 302\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to include("# This is a comment")
      # Comment should not be duplicated with language prefixes
      expect(output.scan('# This is a comment').length).to eq(1)
    end

    it 'should preserve empty lines' do
      write_redirects("/github https://github.com/org/repo 302\n\n/docs https://docs.example.com 301\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      # Original empty line should be preserved
      expect(output).to include("\n\n")
    end

    it 'should handle redirects without status codes' do
      write_redirects("/github https://github.com/org/repo\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to include("/github https://github.com/org/repo")
      expect(output).to include("/es/github https://github.com/org/repo")
    end

    it 'should not localize paths that already have language prefix' do
      write_redirects("/es/old-page /es/new-page 301\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      # Should only have the original line, not /es/es/old-page or /fr/es/old-page
      expect(output.strip).to eq("/es/old-page /es/new-page 301")
    end
  end

  describe 'exclude_from_redirect_localization' do
    it 'should not localize excluded paths' do
      write_redirects("/github https://github.com/org/repo 302\n/signin https://app.example.com/signin 302\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site(
        'localize_redirects' => true,
        'exclude_from_redirect_localization' => ['/signin']
      )
      hook_redirects(site)

      output = read_output_redirects
      # /github should be localized
      expect(output).to include("/es/github https://github.com/org/repo 302")
      # /signin should NOT be localized
      expect(output).not_to include("/es/signin")
      expect(output).not_to include("/fr/signin")
      # But original /signin should still be present
      expect(output).to include("/signin https://app.example.com/signin 302")
    end

    it 'should handle multiple exclusions' do
      write_redirects("/github https://github.com 302\n/signin https://app.example.com/signin 302\n/app https://app.example.com 302\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site(
        'localize_redirects' => true,
        'exclude_from_redirect_localization' => ['/signin', '/app']
      )
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to include("/es/github")
      expect(output).not_to include("/es/signin")
      expect(output).not_to include("/es/app")
    end
  end

  describe 'edge cases' do
    it 'should handle missing _redirects file gracefully' do
      site = create_site('localize_redirects' => true)
      # Should not raise an error
      expect { hook_redirects(site) }.not_to raise_error
    end

    it 'should skip lines that do not start with /' do
      write_redirects("invalid-line\n/valid https://example.com 302\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to include("invalid-line")
      expect(output).to include("/es/valid")
      # invalid-line should not be localized
      expect(output).not_to include("/es/invalid-line")
    end

    it 'should handle splat redirects' do
      write_redirects("/old/* /new/:splat 301\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to include("/old/* /new/:splat 301")
      # Both source and destination should be localized
      expect(output).to include("/es/old/* /es/new/:splat 301")
    end

    it 'should localize internal destination paths' do
      write_redirects("/foo /bar 301\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      expect(output).to include("/foo /bar 301")
      expect(output).to include("/es/foo /es/bar 301")
      expect(output).to include("/fr/foo /fr/bar 301")
      expect(output).to include("/de/foo /de/bar 301")
    end

    it 'should not localize external destination URLs' do
      write_redirects("/github https://github.com/org/repo 302\n")
      FileUtils.cp(File.join(tmpdir, '_redirects'), dest_dir)

      site = create_site('localize_redirects' => true)
      hook_redirects(site)

      output = read_output_redirects
      # External URL should not be prefixed with language
      expect(output).to include("/es/github https://github.com/org/repo 302")
      expect(output).not_to include("/es/github /es/https://")
      expect(output).not_to include("https://es/")
    end
  end
end
