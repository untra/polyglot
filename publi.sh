#! /bin/sh
# change the branch names appropriately
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
