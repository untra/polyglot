# publi.sh
# change the branch names appropriately
git checkout site
rm -rf _site/
jekyll build
git add --all
git commit -m "`date`"
git push origin site
git push origin `git subtree split --prefix _site/ site`:gh-pages --force
