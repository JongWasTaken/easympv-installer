#!/bin/bash

if [[ $(which uglifyjs) == "" ]]; then
    echo "uglifyjs is not in PATH, exiting..."
    exit 1
fi

if [[ -f "master.zip" ]]; then
    echo "master.zip already exists..."
else
    echo "Getting master snapshot..."
    wget https://github.com/JongWasTaken/easympv/archive/refs/heads/master.zip
fi

rm -rf easympv-master/

echo "Extracting..."
unzip master.zip
cd easympv-master/scripts/easympv

echo "Minification..."
mkdir -p min/
mv ./*.js min/
cd min/
uglifyjs Settings.js OS.js UI.js Utils.js Autoload.js API.js Browsers.js Chapters.js Core.js Setup.js Tests.js Video.js --ie -o ./minified.js
sed -i '1s/^/\/\/ For performance reasons, easympv releases contain minified source code. If you wish to modify the source code, you should instead clone the master branch.\n/' minified.js
mv main.js ../
mv Polyfills.js ../
mv minified.js ../
cd ../
rm -rf min/

echo "Packaging..."
cd ../../../
zip -r release.zip easympv-master/*

echo "An mpv window has opened to test the release."
mpv --config-dir="easympv-master" "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
