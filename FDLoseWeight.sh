#!/bin/bash
# http://gitlab.bitautotech.com/WP/Mobile/IOS/BPWelfareLib
# http://gitlab.bitautotech.com/weichao/WelfareMirror
# http://gitlab.bitautotech.com/weichao/WelfareThin
# 在这里把分支保护给关掉http://gitlab.bitautotech.com/weichao/WelfareMirror/settings/repository  点击unprotect，记得完事后重新保护上
# ./FDLoseWeight.sh  /Users/yiche/Code/test/WelfareMirror Example/Pods/ http://gitlab.bitautotech.com/weichao/WelfareThin
# ./FDLoseWeight.sh  /Users/yiche/Code/test/WelfareMirror Example/ http://gitlab.bitautotech.com/weichao/WelfareThin

if [ ! -n "$1" ] ;then
    echo "You have not input a folder path that is git root. "
else
    echo "The folder path that  input is $1"
fi

if [ ! -n "$2" ] ;then
    echo "You have not input a  path to remove. "
else
    echo "The  path to remote is $2"
    # Example/Pods/
    # Example/
fi

if [ ! -n "$3" ] ;then
    echo "You have not input a  thin repo. "
else
    echo "The  thin remote remote is $3"
    # Example/Pods/
    # Example/
fi


echo "run cd"
cd $1
echo "pwd resut:"
pwd
echo "开始瘦身:"

# 先把设置里的分支保护给关掉

# echo "Example/Pods/" >> .gitignore
# git add .gitignore
# git commit -m "Add Example/Pods/ to .gitignore"

git pull --all
# 清除文件
git filter-branch --force --index-filter "git rm -r --ignore-unmatch --cached $2" --prune-empty --tag-name-filter cat -- --all
# 如果文件很多，在下面补充
# git filter-branch --force --index-filter 'git rm -r --cached --ignore-unmatch Example' --prune-empty --tag-name-filter cat -- --all


#Whenever you clone a repo, you do not clone all of its branches by default.
#If you wish to do so, use the following script:
for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
   git branch --track ${branch#remotes/origin/} $branch
done

# 虽然上面我们已经删除了文件, 但是我们的repo里面仍然保留了这些objects, 等待垃圾回收(GC), 所以我们要用命令彻底清除它, 并收回空间.
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now

# 推送我们修改后的repo
# git push origin --force --all
# git push origin  --force --tags

# git remote remove origin
git remote add thin $3
git push -u thin --all
git push -u thin --tags
