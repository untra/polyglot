require "rspec"
require 'rspec/mocks'
# require 'minitest/autorun'
require "jekyll/polyglot"
require "jekyll"

Dir[File.expand_path("../../support/*.rb", __FILE__)].sort.each do |v|
  require v
end

include Jekyll
