require 'ostruct'
require 'minitest/autorun'
require 'jekyll'
include Process

require_relative '../lib/polyglot'

require 'minitest/autorun'

describe Jekyll::Convertible do
  before do
    @site = Jekyll::Site.new(
      Jekyll.configuration(
        'langs' => ['en', 'sp', 'fr', 'de'],
        'source' => File.expand_path('./fixtures', __FILE__)
      )
    )
    @convertible = OpenStruct.new(
      'site' => @site
    )
    @convertible.extend Jekyll::Convertible
    @ru_regex = @convertible.relative_url_regex
  end

  describe 'when asked about cheeseburgers' do
    it 'must respond positively' do
      assert_match(@ru_regex, "href=/about/")
    end
  end
end
