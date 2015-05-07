#!/bin/bash

set -e
set -x

BLD_DIR=`pwd`

SRC_DIR=$RECIPE_DIR/..
pushd $SRC_DIR

version=`$PYTHON scripts/get_bump_version.py`


if [ -e "__travis_build_id__.txt" ]; then
    travis_build_id=$(cat __travis_build_id__.txt)
    echo $version.$travis_build_id > __conda_version__.txt
else
    echo $version > __conda_version__.txt
fi

cp __conda_version__.txt $BLD_DIR

pushd bokehjs
npm install
popd

$PYTHON setup.py --quiet install nightly --build_js --single-version-externally-managed --record=record.txt

mkdir $PREFIX/Examples
cp -r examples $PREFIX/Examples/bokeh

popd

cd $PREFIX
echo $PREFIX

