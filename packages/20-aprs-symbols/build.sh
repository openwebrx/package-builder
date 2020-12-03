#!/usr/bin/env bash
set -euo pipefail

BRANCH_ARG=""
if [[ ! -z ${RELEASE_BRANCH:-} ]]; then
    BRANCH="${RELEASE_BRANCH}"
else
    BRANCH="-b debian/sid"
fi
git clone --depth 1 -b ${BRANCH} https://github.com/jketterl/aprs-symbols-debian.git
pushd aprs-symbols-debian
if [[ ! -z ${BUILD_NUMBER:-} ]]; then
  GBP_ARGS="--debian-branch=${BRANCH} --snapshot --auto --snapshot-number=${BUILD_NUMBER}"
  gbp dch ${GBP_ARGS}
fi
debuild -us -uc
popd