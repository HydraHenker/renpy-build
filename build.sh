#!/bin/sh

# Argument parsing
if [ -z "$1" ]; then
  echo "The SDK version is mandatory"
  return 1
else
  sdk_name=renpy-$1-sdk
fi
if [ -z "$2" ]; then
  dir='.'
else
  dir=$2
fi
if [ -z "$3" ]; then
  packages=""
else
  packages="--package $3"
fi

echo "Downloading SDK (version $1) ..."
wget -q "https://www.renpy.org/dl/$1/${sdk_name}.tar.bz2"
tar -xf "./${sdk_name}.tar.bz2"
rm "./${sdk_name}.tar.bz2"
mv "./${sdk_name}" ../renpy

echo "Building the project at ${dir} ..."
if ../renpy/renpy.sh ../renpy/launcher distribute ${packages} ${dir}; then
    built_dir=$(ls | grep '\-dists')
    echo "::set-output name=dir::$built_dir"
    echo "::set-output name=version::${built_dir%'-dists'}"
else
    return 1
fi
