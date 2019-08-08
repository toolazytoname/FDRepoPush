#! /bin/sh
#--------------------------------------------
# a shell used for  pod lose weight
#
# How to use：
#         (1) get clone this repository
#         (2) chmod +x FD***.sh
#         (3) 想删除单个目录，记得斜杠结尾
#              ./FDLoseWeight.sh  /Users/yiche/Code/test/WelfareMirror（库的根目录） Example/Pods/（想删除的文件夹） http://gitlab.bitautotech.com/weichao/WelfareThin（新目录地址）
#         (4) 想删除多个目录，每个目录斜杠结尾 ，用逗号隔开
#             ./FDLoseWeight.sh  /Users/yiche/Code/test/WelfareMirror（库的根目录） Example/Pods/,Example2（想删除的文件夹数组） http://gitlab.bitautotech.com/weichao/WelfareThin（新目录地址）
#  最理想状态是直接在当前remote操作，但是操作了以后文件是删了，没瘦下来，所以退而求其次，推了个新库。
#
#
#
#  如果要改原来的，在这里把分支保护给关掉http://gitlab.bitautotech.com/weichao/WelfareMirror/settings/repository  点击unprotect，记得完事后重新保护上
# ./FDLoseWeight.sh  /Users/yiche/Code/test/WelfareMirror Example/Pods/ http://gitlab.bitautotech.com/weichao/WelfareThin
# ./FDLoseWeight.sh  /Users/yiche/Code/test/WelfareMirror Example/ http://gitlab.bitautotech.com/weichao/WelfareThin
#
# 可以通过如下命令找到大文件
#https://www.cnblogs.com/lout/p/6111739.html
# git verify-pack -v .git/objects/pack/pack-*.idx | sort -k 3 -g | tail -5
# git rev-list --objects --all | grep 8f10eff91bb6aa2de1f5d096ee2e1687b0eab007
#
#--------------------------------------------


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
    # http://gitlab.bitautotech.com/weichao/WelfareThin
fi


echo "run cd"
cd $1
echo "pwd resut:"
pwd
echo "开始瘦身:"

#  .gitignore 自己手动加吧
# echo "Example/Pods/" >> .gitignore
# git add .gitignore
# git commit -m "Add Example/Pods/ to .gitignore"

git pull --all
# 清除文件
# git filter-branch --force --index-filter "git rm -r --ignore-unmatch --cached $2" --prune-empty --tag-name-filter cat -- --all
oldIFS=$IFS
IFS=,
directory_to_remove_array=($2)
IFS=$oldIFS
for directory_name in ${directory_to_remove_array[@]}; do
  git filter-branch --force --index-filter "git rm -r --ignore-unmatch --cached $directory_name" --prune-empty --tag-name-filter cat -- --all
done

# 如果文件很多，在下面补充
# git filter-branch --force --index-filter 'git rm -r --cached --ignore-unmatch Example' --prune-empty --tag-name-filter cat -- --all


#Whenever you clone a repo, you do not clone all of its branches by default.
#If you wish to do so, use the following script:
for branch in `git branch -a | grep remotes/origin | grep -v HEAD | grep -v master `; do
   git branch --track ${branch#remotes/origin/} $branch
done

# remotes/origin/RMLogin
# remotes/origin/develop
# remotes/origin/flutter
# remotes/origin/navigation
# for branch in  `git branch -r | grep -v 'HEAD\|master'`; do
#  git branch --track ${branch##*/} $branch;
# done
# git branch --track experimental origin/experimental

# 虽然上面我们已经删除了文件, 但是我们的repo里面仍然保留了这些objects, 等待垃圾回收(GC), 所以我们要用命令彻底清除它, 并收回空间.
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --aggressive --prune=now

# 推送我们修改后的repo
# git push origin --force --all
# git push origin  --force --tags

# git remote remove origin
git remote add thin $3
git push -u thin --all
git push -u thin --tags
