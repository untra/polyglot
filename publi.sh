# publi.sh
# change the branch names appropriately
git checkout site
rm -rf _site/
jekyll build
git add --all
git commit -m "`date`"
git push origin site
git subtree push --prefix  _site/ origin gh-pages
