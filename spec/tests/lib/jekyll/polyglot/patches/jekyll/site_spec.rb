require "rspec/helper"
describe Site do
  describe 'document_url_regex' do
    it 'must match common default urls made by jekyll' do
      regex = @site.document_url_regex
      @langs.each do |lang|
        assert_match(regex, "/#{lang}/foobar")
        assert_match(regex, ".#{lang}/foobar")
        assert_match(regex, "foobar.#{lang}/")
      end
    end
    it 'should not match natural unfortunate urls' do
      regex = @site.document_url_regex
      refute_match(regex, 'people/karen/foobar/')
      refute_match(regex, 'verbs/gasp/foobar')
      refute_match(regex, 'products/kefr/foobar.html')
      refute_match(regex, 'properties/beachside/foo')
    end
  end

  describe 'parallel_localization' do
    it 'should default to true if parallel_localization if not set' do
      assert(@parallel_localization)
    end
    it 'should be false if explicitly set' do
      @config['parallel_localization'] = false
      @parallel_localization = @config['parallel_localization'] || true
      assert(@parallel_localization)
    end
  end

  describe 'Convertible relative_url_regex' do
    it 'must match certain strings with any simple baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        regex = @site.relative_url_regex
        assert_match(regex, "href=\"#{baseurl}/about/\"")
        assert_match(regex, "href=\"#{baseurl}/\"")
        assert_match(regex, "href=\"#{baseurl}/purchase/product/1234-business\"")
      end
    end

    it 'must match with an empty baseurl' do
      regex = @site.relative_url_regex
      assert_match(regex, 'href="/about/"')
      assert_match(regex, 'href="/"')
      assert_match(regex, 'href="/purchase/product/1234-business"')
    end

    it 'must not match external urls' do
      regex = @site.relative_url_regex
      refute_match(regex, 'href="http://github.com"')
      refute_match(regex, 'href="https://talk.jekyllrb.com')
      refute_match(regex, 'href="http://google.com"')
      refute_match(regex, 'href="https://untra.github.io/polyglot"')
    end

    it 'must not match excluded urls' do
      @site.exclude += @exclude_from_localization
      regex = @site.relative_url_regex
      refute_match(regex, 'href="/images/my-vacation-photo.jpg"')
      refute_match(regex, 'href="/css/stylesheet.css"')
      refute_match(regex, 'href="/javascript/65487-app.js"')
    end

    it 'must not match excluded urls with a set baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @site.exclude += @exclude_from_localization
        regex = @site.relative_url_regex
        refute_match(regex, "href=\"#{baseurl}/javascript/65487-app.js\"")
        refute_match(regex, "href=\"#{baseurl}/images/my-vacation-photo.jpg\"")
        refute_match(regex, "href=\"#{baseurl}/css/stylesheet.css\"")
      end
    end

    it 'must not match localized urls' do
      regex = @site.relative_url_regex
      @langs.each do |lang|
        refute_match(regex, "href=\"#{lang}/about/\"")
        refute_match(regex, "href=\"#{lang}/\"")
        refute_match(regex, "href=\"#{lang}/purchase/product/1234-business\"")
      end
    end

    it 'must not match localized urls with a set baseurl' do
      @baseurls.each do |baseurl|
        @site.baseurl = baseurl
        @site.exclude += @exclude_from_localization
        regex = @site.relative_url_regex
        refute_match(regex, "href=\"#{baseurl}/javascript/65487-app.js\"")
        refute_match(regex, "href=\"#{baseurl}/images/my-vacation-photo.jpg\"")
        refute_match(regex, "href=\"#{baseurl}/css/stylesheet.css\"")
      end
    end
  end
end
