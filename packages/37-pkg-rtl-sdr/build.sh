#!/usr/bin/env bash
set -euo pipefail

if [[ ! -z ${RELEASE_BRANCH:-} ]]; then
    source /etc/os-release
    BRANCH="${ID}/${VERSION_CODENAME}"
else
    BRANCH="debian/sid"
fi
git clone -b ${BRANCH} https://github.com/openwebrx/pkg-rtl-sdr
git clone git://git.osmocom.org/rtl-sdr
pushd rtl-sdr
# need to create our own tarball from git since the ones available for download don't match the packaging instructions
git archive --format tar.gz -o ../rtl-sdr_0.6.0.orig.tar.gz 0.6.0
popd
pushd pkg-rtl-sdr
tar xvfz ../rtl-sdr_0.6.0.orig.tar.gz
if [[ ! -z ${BUILD_NUMBER:-} ]]; then
  GBP_ARGS="--debian-branch=${BRANCH} --snapshot --auto --snapshot-number=${BUILD_NUMBER}"
  gbp dch ${GBP_ARGS}
  git add debian/changelog
  git commit -m "snapshot changelog"
fi
debuild -us -uc
popd