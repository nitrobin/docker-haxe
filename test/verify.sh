#!/usr/bin/env bash

cd $(dirname "$0")

BUILDDIR=$(pwd)/build

mkdir -p $BUILDDIR

haxe build.hxml

echo "################################################################################"
echo "Haxe targets test: "

build/cpp/Test          && echo '> C++ passed'
node build/test.js      && echo '> JavaScript passed'
python3 build/test.py   && echo '> Python passed'
php build/php/index.php && echo '> PHP passed'
neko build/test.n       && echo '> Neko passed'

if [ -e build/test.swf  ]
then
  echo '> Flash/SWF passed'
fi

if [ -e build/as3/Test.as  ]
then
  echo '> ActionScript 3 passed'
fi

echo "################################################################################"

rm -rf $BUILDDIR
