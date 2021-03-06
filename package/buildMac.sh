#!/bin/bash

TOOLCHAIN=/Applications/Xcode10.3.app/Contents/Developer

LAST_TC=$(xcode-select -p)
sudo xcode-select -s $TOOLCHAIN

xcodebuild -project Server/Builds/MacOSX/AudioGridderServer.xcodeproj -alltargets -configuration Release clean
xcodebuild -project Server/Builds/MacOSX/AudioGridderServer.xcodeproj -alltargets -configuration Release build
xcodebuild -project Server/Builds/MacOSX10.7/AudioGridderServer.xcodeproj -alltargets -configuration Release clean
xcodebuild -project Server/Builds/MacOSX10.7/AudioGridderServer.xcodeproj -alltargets -configuration Release build
xcodebuild -project Plugin/Fx/Builds/MacOSX/AudioGridder.xcodeproj -alltargets -configuration Release clean
xcodebuild -project Plugin/Fx/Builds/MacOSX/AudioGridder.xcodeproj -alltargets -configuration Release build
xcodebuild -project Plugin/Inst/Builds/MacOSX/AudioGridderInst.xcodeproj -alltargets -configuration Release clean
xcodebuild -project Plugin/Inst/Builds/MacOSX/AudioGridderInst.xcodeproj -alltargets -configuration Release build

sudo xcode-select -s $LAST_TC

VERSION=$(cat package/VERSION)

if [ -n "$(which packagesbuild)" ]; then
    echo

    TARGET=package/build/AudioGridderPlugin_${VERSION}.pkg
    packagesbuild --package-version "$VERSION" package/AudioGridderPlugin.pkgproj
    mv package/build/AudioGridderPlugin.pkg $TARGET
    echo "Created $TARGET"

    TARGET=package/build/AudioGridderServer_${VERSION}.pkg
    packagesbuild --package-version "$VERSION" package/AudioGridderServer.pkgproj
    mv package/build/AudioGridderServer.pkg $TARGET
    echo "Created $TARGET"

    TARGET=package/build/AudioGridderServer10.7_${VERSION}.pkg
    packagesbuild --package-version "$VERSION" package/AudioGridderServer10.7.pkgproj
    mv package/build/AudioGridderServer10.7.pkg $TARGET
    echo "Created $TARGET"
fi

cp -r Server/Builds/MacOSX/build/Release/AudioGridderServer.app ../Archive/Builds/$VERSION/osx/
cp -r Server/Builds/MacOSX10.7/build/Release/AudioGridderServer.app ../Archive/Builds/$VERSION/osx10.7/
cp -r Plugin/Fx/Builds/MacOSX/build/Release/AudioGridder.* ../Archive/Builds/$VERSION/osx/
cp -r Plugin/Inst/Builds/MacOSX/build/Release/AudioGridderInst.* ../Archive/Builds/$VERSION/osx/

cd package/build
zip AudioGridder_$VERSION-osx.zip AudioGridderPlugin_$VERSION.pkg AudioGridderServer10.7_$VERSION.pkg AudioGridderServer_$VERSION.pkg
rm AudioGridderPlugin_$VERSION.pkg AudioGridderServer10.7_$VERSION.pkg AudioGridderServer_$VERSION.pkg
cd -
