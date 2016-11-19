# /bin/sh
VERSION="1.2.2"
gem build jekyll-polyglot.gemspec
sudo gem install jekyll-polyglot-$VERSION.gem
cd site
jekyll build --no-watch
