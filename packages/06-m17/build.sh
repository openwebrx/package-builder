#!/usr/bin/env bash
set -euo pipefail

git clone -b debian https://github.com/jketterl/m17-cxx-demod.git
pushd m17-cxx-demod
gbp buildpackage --git-debian-branch=debian
popd