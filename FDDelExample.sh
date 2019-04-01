#!/bin/bash


git filter-branch --force --index-filter 'git rm -r --cached --ignore-unmatch Example' --prune-empty --tag-name-filter cat -- --all


rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now

# git push origin --force --all
# git push origin  --force --tags

git remote remove origin
git remote add origin http://gitlab.bitautotech.com/WP/Mobile/IOS/ThinNews

git push -u origin --all
git push -u origin --tags