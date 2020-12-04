#!/usr/bin/env bash
set -euo pipefail

if [[ ! -z ${RELEASE_BRANCH:-} ]]; then
    source /etc/os-release
    BRANCH="${ID}/${VERSION_CODENAME}"
else
    BRANCH="experimental"
fi
git clone -b ${BRANCH} https://github.com/jketterl/dsd.git
pushd dsd
if [[ ! -z ${BUILD_NUMBER:-} ]]; then
  GBP_ARGS="--debian-branch=${BRANCH} --snapshot --auto --snapshot-number=${BUILD_NUMBER}"
  gbp dch ${GBP_ARGS}
  git add debian/changelog
  git commit -m "snapshot changelog"
fi
gbp buildpackage --git-debian-branch=$BRANCH -us -uc
popd