#! /bin/sh
VERSION="1.5.0"
# this is running tests
gem build jekyll-polyglot.gemspec
gem install jekyll-polyglot-$VERSION.gem
cd site
rm -rf _site/
jekyll build --no-watch
