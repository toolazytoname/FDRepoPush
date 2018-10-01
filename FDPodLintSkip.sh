#! /bin/sh

#--------------------------------------------
# a shell used for CocoaPods pod lib lint
#
# How to use：
#         (1) get clone this repository
#         (2) chmod +x FD***.sh
#         (3) ./FD****.sh path(input a folder path that contains a podspec file)
#--------------------------------------------

if [ ! -n "$1" ] ;then
    echo "You have not input a folder path that contains a podspec file. "
else
    echo "The folder path that contains a podspec file input is $1"
fi

echo "run cd"
cd $1
echo "pwd resut:"
pwd
echo "pod lib lint --skip-import-validation start:"
pod lib lint --sources='http://gitlab.bitautotech.com/WP/Mobile/IOS/Specs.git,https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --fail-fast --skip-import-validation
