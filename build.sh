#!/usr/bin/env bash

git submodule sync
git submodule update --init --recursive

pip install pyyaml typing-extensions numpy pynvim

cd conan
rm -rf generators
conan install .
source generators/conan_shell_export.sh
cd ..

export OPENSSL_ROOT_DIR=$openssl_ROOT_SINGLE_DIR
echo "OPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR"
export CMAKE_PREFIX_PATH=$abseil_LIB_SINGLE_DIR/cmake:$protobuf_LIB_SINGLE_DIR/cmake:$onnx_LIB_SINGLE_DIR/cmake
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
export PYTORCH_BUILD_VERSION=2.2.0
export PYTORCH_BUILD_NUMBER=0
python setup.py bdist_wheel
