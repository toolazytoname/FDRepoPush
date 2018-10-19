#! /bin/sh

#--------------------------------------------
# a shell used for CocoaPods pod repo push
#warnings:
#         (1) my repo name in local is BPSpecs,
#             you should change the key word to your own repo name
#
# How to use：
#         (1) get clone this repository
#         (2) chmod +x FD***.sh
#         (3) ./FD****.sh path(input a folder path that contains a podspec file)
#--------------------------------------------
repoName="BPSpecs"

if [ ! -n "$1" ] ;then
    echo "You have not input a folder path that contains a podspec file. "
else
    echo "The folder path that contains a podspec file input is $1"
fi

echo "run cd"
cd $1
echo "pwd resut:"
pwd

echo "pod repo push  start:"
pod repo push BPSpecs  --sources='http://gitlab.bitautotech.com/WP/Mobile/IOS/Specs.git,https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries
