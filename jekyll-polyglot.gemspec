Gem::Specification.new do |s|
  s.name        = 'jekyll-polyglot'
  s.version     = '1.8.1'
  s.date        = '2024-08-18'
  s.summary     = 'I18n plugin for Jekyll Blogs'
  s.description = 'Fast open source i18n plugin for Jekyll blogs.'
  s.authors     = ['Samuel Volin']
  s.email       = 'untra.sam@gmail.com'
  s.files       = ['README.md', 'LICENSE'] + Dir['lib/**/*']
  s.homepage    = 'https://polyglot.untra.io/'
  s.license     = 'MIT'
  s.add_runtime_dependency('jekyll', '>= 3.0', '>= 4.0')
  s.required_ruby_version     = '>= 2.7.0'
  s.required_rubygems_version = '>= 2.7.0'
end
