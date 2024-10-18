#!/usr/bin/env bash

VERSION=2.5.0

git submodule sync
git submodule update --init --recursive

pip install pyyaml typing-extensions numpy pynvim setuptools twine

cd conan
rm -rf generators
conan install .
. generators/conan_shell_export.sh
cd ..

export OPENSSL_ROOT_DIR=$openssl_ROOT_SINGLE_DIR
echo "OPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR"
export CMAKE_PREFIX_PATH=$abseil_LIB_SINGLE_DIR/cmake:$protobuf_LIB_SINGLE_DIR/cmake/protobuf:$onnx_LIB_SINGLE_DIR/cmake
echo "CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH"
# see tools/setup_helpers/cmake.py:189
export _GLIBCXX_USE_CXX_ABI=1
# see tools/setup_helpers/cmake.py:258
export BUILD_TEST=0
export BUILD_CUSTOM_PROTOBUF=0
export USE_SYSTEM_ONNX=1
export LD_LIBRARY_PATH=$abseil_LIB_SINGLE_DIR:$protobuf_LIB_SINGLE_DIR

git submodule update --init --recursive
export TORCH_PACKAGE_NAME=chong-torch
export PYTORCH_BUILD_VERSION=$VERSION
export PYTORCH_BUILD_NUMBER=0
export CC=gcc-13
export CXX=g++-13
python setup.py bdist_wheel
twine upload -r fhong dist/chong_torch-$VERSION-cp312-cp312-linux_x86_64.whl
