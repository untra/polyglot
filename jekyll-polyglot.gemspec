Gem::Specification.new do |s|
  s.name        = 'jekyll-polyglot'
  s.version     = '1.3.2'
  s.date        = '2020-04-28'
  s.summary     = 'I18n plugin for Jekyll Blogs'
  s.description = 'Fast open source i18n plugin for Jekyll blogs.'
  s.authors     = ['Samuel Volin']
  s.email       = 'untra.sam@gmail.com'
  s.files       = ['README.md', 'LICENSE'] + Dir['lib/**/*']
  s.homepage    =
    'http://untra.github.io/polyglot'
  s.license     = 'MIT'
  s.add_runtime_dependency('jekyll', '>= 3.0')
end
