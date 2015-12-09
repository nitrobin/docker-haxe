#!/usr/bin/env bash

cd $(dirname "$0")

BUILDDIR=$(pwd)/build

mkdir -p $BUILDDIR

haxe build.hxml

echo "################################################################################"
echo "Haxe targets test: "

haxe build.hxml -swf build/test.swf
if [ -e build/test.swf  ]
then
  echo '> Flash/SWF PASSED'
fi

haxe build.hxml -as3 build/as3
if [ -e build/as3/Test.as  ]
then
  echo '> ActionScript 3 PASSED'
fi

haxe build.hxml -js build/test.js     && node build/test.js > /dev/null      && echo '> JavaScript PASSED'
haxe build.hxml -python build/test.py && python3 build/test.py > /dev/null   && echo '> Python PASSED'
haxe build.hxml -php build/php        && php build/php/index.php > /dev/null && echo '> PHP PASSED'
haxe build.hxml -neko build/test.n    && neko build/test.n > /dev/null       && echo '> Neko PASSED'
haxe build.hxml -cpp build/cpp > /dev/null && build/cpp/Test  > /dev/null   && echo '> C++ PASSED'

echo "################################################################################"

rm -rf $BUILDDIR

echo "Haxelib installed libraries:"

haxelib list

echo "################################################################################"

echo "HAXE" $(haxe -version 2>&1)
echo "NEKO" $(neko -version)
echo "NODEJS " $(node --version)

echo "################################################################################"
