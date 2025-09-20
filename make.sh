#! /bin/sh
VERSION="1.11.0"
# this is running tests
gem build jekyll-polyglot.gemspec
gem install jekyll-polyglot-$VERSION.gem
cd site
rm -rf _site/
bundle exec jekyll build --no-watch
