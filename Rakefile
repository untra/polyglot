require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task :default => [:spec]

desc 'Build the example site at ./site'
task :site_build do
  Dir.chdir('site') do
    sh 'bundle exec jekyll build'
  end
end

desc 'Run html-proofer on the built example site'
task :htmlproofer => [:site_build] do
  require 'html-proofer'
  HTMLProofer.check_directory(
    './site/_site',
    disable_external: true,
    allow_hash_href: true,
    root_dir: './site/_site',
    swap_urls: { %r{^https://polyglot\.untra\.io} => '' }
  ).run
end
