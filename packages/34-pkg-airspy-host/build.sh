#!/usr/bin/env bash
set -euo pipefail

if [[ ! -z ${RELEASE_BRANCH:-} ]]; then
    source /etc/os-release
    BRANCH="${ID}/${VERSION_CODENAME}"
else
    BRANCH="debian/sid"
fi
git clone -b ${BRANCH} https://github.com/openwebrx/pkg-airspy-host
wget -O airspyone-host_1.0.10.orig.tar.gz https://github.com/airspy/airspyone_host/archive/refs/tags/v1.0.10.tar.gz
pushd pkg-airspy-host
tar xvfz ../airspyone-host_1.0.10.orig.tar.gz --strip-components=1
if [[ ! -z ${BUILD_NUMBER:-} ]]; then
  GBP_ARGS="--debian-branch=${BRANCH} --snapshot --auto --snapshot-number=${BUILD_NUMBER}"
  gbp dch ${GBP_ARGS}
  git add debian/changelog
  git commit -m "snapshot changelog"
fi
debuild -us -uc
popd