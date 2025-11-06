#!/bin/bash
PROJECTDIR=`pwd`
set -e
echo "Building latest Elecree Version. Version number?"
read VERSION
echo "Pushing source to Github..."
git add .
git commit -m $VERSION
git checkout -b $VERSION
gh pr create
clear
echo "Building source..."
mkdir ~/elecree_binaries/$VERSION
cd ~/elecree-binaries/$VERSION
mkdir lin64 win64 lin32 win32
cd $PROJECTDIR
godot3 --export "Linux/X11" ~/elecree-binaries/$VERSION/lin64/elecree-$VERSION-lin64.x86-64
godot3 --export "Windows Desktop" ~/elecree-binaries/$VERSION/win64/elecree-$VERSION-win64.exe
godot3 --export "Linux 32-Bit" ~/elecree-binaries/$VERSION/lin32/elecree-$VERSION-lin32.x86
godot3 --export "Windows 32-Bit" ~/elecree-binaries/$VERSION/win32/elecree-$VERSION-win32.exe
godot3 --export "Mac OSX" ~/elecree-binaries/$VERSION/elecree-$VERSION-mac.zip
clear
echo "Creating Binaries..."
cd ~/elecree-binaries/$VERSION
zip elecree-$VERSION-lin64.zip lin64/*
zip elecree-$VERSION-win64.zip win64/*
zip elecree-$VERSION-lin32.zip lin32/*
zip elecree-$VERSION-win32.zip win32/*
echo "Complete!"
