#!/bin/bash
set -e
export DEVICE=panther
export ROM_MANIFEST="https://github.com/PixelOS-AOSP/manifest"
export ROM_BRANCH="fourteen"
export BUILD_TYPE=userdebug

sudo apt-get update && sudo apt-get install -y git-core repo curl zip unzip python3 python3-pip
git config --global user.name "ONLY1WAY2DIE"
git config --global user.email "dev@only1way2die.example"

mkdir -p ~/android/rom && cd ~/android/rom
repo init -u $ROM_MANIFEST -b $ROM_BRANCH --depth=1
mkdir -p .repo/local_manifests
cp /path/to/local_manifests/pixelos_panther_a14.xml .repo/local_manifests/
repo sync -j4
source build/envsetup.sh
lunch aosp_panther-$BUILD_TYPE
mka bacon
