#!/bin/bash
set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git clone https://github.com/sstephenson/bats.git
pushd bats
./install.sh /home/jovyan/
popd

pushd ${DIR}
/home/jovyan/bin/bats tests.bats
popd
