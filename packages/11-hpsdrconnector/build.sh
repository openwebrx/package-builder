#!/usr/bin/env bash
set -euo pipefail

source /etc/os-release
BRANCH="${ID}/${VERSION_CODENAME}"

git clone https://github.com/openwebrx/hpsdrconnector-debian
pushd hpsdrconnector-debian
git checkout $BRANCH
gbp buildpackage --git-debian-branch=$BRANCH
popd