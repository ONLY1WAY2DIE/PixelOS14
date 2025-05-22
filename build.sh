#!/bin/bash
cd "$GITHUB_WORKSPACE" || cd "$HOME/actions-runner/_work/PixelOS14/PixelOS14" || cd "$HOME/_work/PixelOS14/PixelOS14"
echo "PWD: $(pwd)"
ls -l
ls -l local_manifests || echo "Ordner local_manifests nicht gefunden!"
ls -l local_manifests/Pixelos_panther_a14.xml || echo "Datei Pixelos_panther_a14.xml nicht gefunden!"
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

# Intelligentes Copy: Datei suchen und an richtige Stelle kopieren
FOUND_MANIFEST="$(find $GITHUB_WORKSPACE local_manifests . -name Pixelos_panther_a14.xml 2>/dev/null | head -n1)"
if [ -z "$FOUND_MANIFEST" ]; then
  echo "Local manifest wurde NICHT gefunden – Build abgebrochen!"
  exit 1
else
  echo "Local manifest gefunden: $FOUND_MANIFEST"
  cp "$FOUND_MANIFEST" .repo/local_manifests/
fi

repo sync -j4
source build/envsetup.sh
lunch aosp_panther-$BUILD_TYPE
mka bacon
