# /bin/sh
VERSION="1.3.2"
gem build jekyll-polyglot.gemspec
gem install jekyll-polyglot-$VERSION.gem
cd site
rm -rf _site/
jekyll build --no-watch
