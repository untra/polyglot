# /bin/sh
VERSION="1.3.1"
gem build jekyll-polyglot.gemspec
sudo gem install jekyll-polyglot-$VERSION.gem
cd site
rm -rf _site/
jekyll build --no-watch
