#!/usr/bin/env bash

VERSION=2.7.1

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
export TORCH_CUDA_ARCH_LIST="7.5;8.6"

git submodule update --init --recursive
export TORCH_PACKAGE_NAME=chong-torch
export PYTORCH_BUILD_VERSION=$VERSION
export PYTORCH_BUILD_NUMBER=0
if [[ "$OSTYPE" == "darwin"* ]]; then
    export CC=clang-19
    export CXX=clang-19
    export CXX_FLAGS="-nostdinc++ -nostdlib++ -isystem /opt/homebrew/opt/llvm/include/c++/v1"
    export LDFLAGS="-nostdlib++ -L /opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++ -lc++"
    export USE_CUDA=0
elif [[ "$OSTYPE" == "linux"* ]]; then
    export CC=gcc-13
    export CXX=g++-13
fi
python setup.py bdist_wheel
