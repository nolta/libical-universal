#! /bin/sh

configuration="Release"
xcodebuild=/Developer/usr/bin/xcodebuild
output="build/universal"
product="${output}/libical-universal.a"

mkdir -p $output
rm -f $product
rm -Rf "$output/headers"
rm -Rf "$output/resources"

sdks=( iphoneos3.2 iphonesimulator3.2 )
for i in "${sdks[@]}"
do
	$xcodebuild -target libical -configuration $configuration -sdk "$i" clean build
done

products=( `ls build/${configuration}-*/libical.a` )
echo ${products[@]}
lipo -create ${products[@]} -output $product

headers=( `ls -d build/${configuration}-*/headers` )
resources=( `ls -d build/${configuration}-*/resources` )

cp -R ${headers:0} $output
cp -R ${resources:0} $output

