#!/usr/bin/env bash
set -euo pipefail

if grep -q "Debian" /etc/os-release; then
  BRANCH=debian/buster
else
  BRANCH=ubuntu/groovy
fi

git clone https://github.com/openwebrx/hpsdr-debian
pushd hpsdr-debian
git checkout $BRANCH
gbp buildpackage --git-debian-branch=$BRANCH
popd