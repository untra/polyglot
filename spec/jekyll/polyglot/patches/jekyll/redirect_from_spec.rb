require 'jekyll'
require 'rspec/helper'
require 'fileutils'
require 'tmpdir'

describe 'redirect_from localization' do
  let(:source) { Dir.mktmpdir }
  let(:destination) { File.join(source, '_site') }

  around do |example|
    generators = Jekyll::Generator.instance_variable_get(:@children)&.dup

    begin
      require 'jekyll-redirect-from'
      # reregister generator in case a previous test ensure block stripped it back out
      children = Jekyll::Generator.instance_variable_get(:@children) || Set.new
      children.add(JekyllRedirectFrom::Generator)
      Jekyll::Generator.instance_variable_set(:@children, children)
      example.run
    ensure
      Jekyll::Generator.instance_variable_set(:@children, generators)
    end
  end

  after do
    FileUtils.rm_rf(source)
  end

  def write_page(filename, lang)
    File.write(
      File.join(source, filename),
      <<~MARKDOWN
        ---
        lang: #{lang}
        permalink: /blog/new-title/
        redirect_from:
          - /blog/old-title/
        ---
        #{lang}
      MARKDOWN
    )
  end

  def build_site
    Site.new(
      Jekyll.configuration(
        'source'                => source,
        'destination'           => destination,
        'languages'             => ['en', 'de'],
        'default_lang'          => 'en',
        'parallel_localization' => false,
        'url'                   => 'https://test.github.io',
        'plugins'               => ['jekyll-redirect-from']
      )
    )
  end

  it 'writes secondary-language redirects without duplicating the locale prefix' do
    write_page('new-title.en.md', 'en')
    write_page('new-title.de.md', 'de')

    build_site.process

    redirect = File.join(destination, 'de', 'blog', 'old-title', 'index.html')
    duplicated = File.join(destination, 'de', 'de', 'blog', 'old-title', 'index.html')

    expect(File).to exist(redirect)
    expect(File).not_to exist(duplicated)
    expect(File.read(redirect)).to include('https://test.github.io/de/blog/new-title/')
  end

  it 'points script and meta refresh targets at the localized page' do
    write_page('new-title.en.md', 'en')
    write_page('new-title.de.md', 'de')

    build_site.process

    de_redirect = File.read(File.join(destination, 'de', 'blog', 'old-title', 'index.html'))
    en_redirect = File.read(File.join(destination, 'blog', 'old-title', 'index.html'))

    expect(de_redirect).to include('<script>location="https://test.github.io/de/blog/new-title/"</script>')
    expect(de_redirect).to include('url=https://test.github.io/de/blog/new-title/')
    expect(de_redirect).not_to include('url=https://test.github.io/blog/new-title/')

    expect(en_redirect).to include('<script>location="https://test.github.io/blog/new-title/"</script>')
    expect(en_redirect).to include('url=https://test.github.io/blog/new-title/')
    expect(en_redirect).not_to include('/en/')
  end
end
