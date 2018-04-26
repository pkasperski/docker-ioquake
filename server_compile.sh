#!/bin/bash

set -e

export BUILD_CLIENT="${BUILD_CLIENT:-0}"
export BUILD_SERVER="${BUILD_SERVER:-1}"
export USE_CURL="${USE_CURL:-1}"
export USE_CODEC_OPUS="${USE_CODEC_OPUS:-1}"
export USE_VOIP="${USE_VOIP:-1}"
export COPYDIR="${COPYDIR:-~/ioquake3}"
IOQ3REMOTE="${IOQ3REMOTE:-https://github.com/ioquake/ioq3.git}"
MAKE_OPTS="-j$(nproc)"

BUILD_DIR="$(mktemp -d)"
trap "rm -rf $BUILD_DIR" EXIT

git clone --depth 1 $IOQ3REMOTE $BUILD_DIR/ioq3
cd $BUILD_DIR/ioq3
make $MAKE_OPTS
make copyfiles