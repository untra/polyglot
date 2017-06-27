require 'rspec/helper'
require 'ostruct'
require_relative '../../../../../../lib/jekyll/polyglot/hooks/coordinate'
describe 'hook_coordinate' do
  before do
    @config = Jekyll::Configuration::DEFAULTS.dup
    @langs = ['en', 'fr']
    @default_lang = 'en'
    @exclude_from_localization = ['javascript', 'images', 'css']
    @config['langs'] = @langs
    @config['default_lang'] = @default_lang
    @config['exclude_from_localization'] = @exclude_from_localization
    @parallel_localization = @config['parallel_localization'] || true
    @site = Site.new(
      Jekyll.configuration(
        'languages'                 => @langs,
        'default_lang'              => @default_lang,
        'exclude_from_localization' => @exclude_from_localization,
        'source'                    => File.expand_path('./fixtures', __FILE__)
      )
    )
    @site.prepare
    @site.data = { 'foo' => 'databar', 'baz' => 'databaz' }
    @site.data['en'] = { 'foo' => 'enbar', 'strings' => {
      'apple' => 'apple', 'ice cream' => 'ice cream',
    }, }
    @site.data['fr'] = { 'foo' => 'frbar', 'strings' => {
      'ice cream' => 'crème glacée',
    }, }
  end

  it 'should merge the site.data.active_lang to the site.data' do
    hook_coordinate(@site)
    expect(@site.data['foo']).to eq('enbar')
    expect(@site.data['baz']).to eq('databaz')
  end
end
