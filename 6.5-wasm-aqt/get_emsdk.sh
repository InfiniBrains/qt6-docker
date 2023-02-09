#!/usr/bin/env bash
# Script to get emscripten sdk

[ "$SDK_URL" ]    || SDK_URL="https://github.com/emscripten-core/emsdk/archive/refs/tags/3.1.31.tar.gz"
[ "$SDK_PATH" ] || SDK_PATH=/opt/emsdk

root_dir=$PWD
[ "$root_dir" != '/' ] || root_dir=""

# Init the package system
apt update

echo
echo '--> Save the original installed packages list'
echo

dpkg --get-selections | cut -f 1 > /tmp/packages_orig.lst

echo
echo '--> Install EmSDK'
echo

apt install -y curl python-is-python3

echo curl -fLs "$SDK_URL" | tee /tmp/emsdk.tar.gz
mkdir -p /opt/emsdk
tar --strip-components 1 -C /opt/emsdk -xf /tmp/emsdk.tar.gz
rm -f /tmp/emsdk.tar.gz
/opt/emsdk/emsdk install 3.1.25
/opt/emsdk/emsdk activate 3.1.25 --permanent

# Make sure node tool exist
ls "$EMSDK_NODE"

echo
echo '--> Restore the packages list to the original state'
echo

dpkg --get-selections | cut -f 1 > /tmp/packages_curr.lst
grep -Fxv -f /tmp/packages_orig.lst /tmp/packages_curr.lst | xargs apt remove -y --purge

# Complete the cleaning

cd /tmp
rm -rf $root_dir/build
apt -qq clean
rm -rf /var/lib/apt/lists/*
