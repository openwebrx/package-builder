#!/usr/bin/env bash
set -euo pipefail

if [[ ! -z ${RELEASE_BRANCH:-} ]]; then
    source /etc/os-release
    BRANCH="${ID}/${VERSION_CODENAME}"
else
    BRANCH="debian/sid"
fi
git clone -b ${BRANCH} https://github.com/openwebrx/pkg-rtl-sdr
wget -O rtl-sdr_2.0.1.orig.tar.gz https://gitea.osmocom.org/sdr/rtl-sdr/archive/v2.0.1.tar.gz
pushd pkg-rtl-sdr
tar xvfz ../rtl-sdr_2.0.1.orig.tar.gz --exclude=debian
if [[ ! -z ${BUILD_NUMBER:-} ]]; then
  GBP_ARGS="--debian-branch=${BRANCH} --snapshot --auto --snapshot-number=${BUILD_NUMBER}"
  gbp dch ${GBP_ARGS}
  git add debian/changelog
  git commit -m "snapshot changelog"
fi
debuild -us -uc
popd