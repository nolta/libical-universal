#! /bin/sh

configuration="Release"
xcodebuild=/Developer/usr/bin/xcodebuild
output="build/universal"
product="${output}/libical-universal.a"

mkdir -p $output
rm -f $product

sdks=( iphoneos3.2 iphonesimulator3.2 )
for i in "${sdks[@]}"
do
	$xcodebuild -target libical -configuration $configuration -sdk "$i" clean build
done

products=( `ls build/${configuration}-*/libical.a` )
echo ${products[@]}
lipo -create ${products[@]} -output $product

