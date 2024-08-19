@echo off
set VERSION="1.8.1"
REM this is running tests
CALL gem build jekyll-polyglot.gemspec
CALL gem install jekyll-polyglot-%VERSION%.gem
cd site
rm -recurse -force _site/
CALL bundle exec jekyll build --no-watch
