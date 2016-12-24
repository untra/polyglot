# /bin/sh
VERSION="1.2.4"
gem build jekyll-polyglot.gemspec
sudo gem install jekyll-polyglot-$VERSION.gem
cd site
jekyll build --no-watch
