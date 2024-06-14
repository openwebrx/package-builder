#!/usr/bin/env bash
set -euo pipefail

if [[ ! -z ${RELEASE_BRANCH:-} ]]; then
    source /etc/os-release
    BRANCH="${ID}/${VERSION_CODENAME}"
else
    BRANCH="debian/sid"
fi
git clone -b ${BRANCH} https://github.com/openwebrx/dream-debian
wget -O dream_2.1.1.orig.tar.gz https://downloads.sourceforge.net/project/drm/dream/2.1.1/dream-2.1.1-svn808.tar.gz
pushd dream-debian
# this directory causes weird permission issues. this is just a workaround.
mkdir -p src/macx
tar xvfz ../dream_2.1.1.orig.tar.gz --strip-components=1
if [[ ! -z ${BUILD_NUMBER:-} ]]; then
  GBP_ARGS="--debian-branch=${BRANCH} --snapshot --auto --snapshot-number=${BUILD_NUMBER}"
  gbp dch ${GBP_ARGS}
  git add debian/changelog
  git commit -m "snapshot changelog"
fi
debuild -us -uc
popd