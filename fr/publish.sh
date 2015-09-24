# Push source branch
git checkout master
git add -A
git commit
git push origin master

# Push master branch
jekyll build
git checkout master
git rm -qr .
cp -r _site/. .
rm -r _site
git add -A
git commit
git push origin gh-pages
