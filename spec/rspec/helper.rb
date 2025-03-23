require "rspec"
require 'rspec/mocks'
# require 'minitest/autorun'
require 'simplecov'
require 'simplecov-json'

SimpleCov.configure do
  enable_coverage :branch

  # Track files in lib directory
  track_files "lib/**/*.rb"

  # Add filters for test and vendor files
  add_filter '/spec/'
  add_filter '/test/'
  add_filter '/vendor/'
  add_filter '/.bundle/'

  # Configure output directory
  coverage_dir File.join(File.dirname(__FILE__), '..', '..', 'coverage')

  # Use JSON formatter
  formatter SimpleCov::Formatter::JSONFormatter

  # Minimum coverage threshold
  minimum_coverage 0
end

SimpleCov.start

# Require project files after SimpleCov.start
require "jekyll/polyglot"
require "jekyll"
require 'codecov'

Dir[File.expand_path("../../support/*.rb", __FILE__)].each do |v|
  require v
end

include Jekyll
