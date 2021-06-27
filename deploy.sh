#!/bin/bash
git config user.name "huang"
git config user.email "huang19891023@163.com"
git config --global core.quotepath false

git checkout -b gitbook
git status
git add .
git commit -am "[Travis] Update SUMMARY.md"
git push -f "https://${GH_TOKEN}@${GH_REF}" gitbook:gitbook
sed -i 's/fs.*stat = statFix(fs.*stat)/\/\/ &/g' /home/travis/.nvm/versions/node/v12.22.1/lib/node_modules/gitbook-cli/node_modules/npm/node_modules/graceful-fs/polyfills.js
gitbook install
gitbook build .
if [ $? -ne 0 ];then
    exit 1
fi
cd _book
sed -i '/a href.*\.md/s#\.md#.html#g;/a href.*README\.html/s#README\.html##g' SUMMARY.html
git init
git config user.name "huang"
git config user.email "huang19891023@163.com"
git checkout --orphan gh-pages
git status
sleep 5
git add .
git commit -m "Update gh-pages"
git remote add origin git@github.com:bond-huang/ebook.git
git push -f "https://${GH_TOKEN}@${GH_REF}" gh-pages:gh-pages
