#!/usr/bin/env bash
set -euo pipefail

if [[ ! -z ${RELEASE_BRANCH:-} ]]; then
    source /etc/os-release
    BRANCH="${ID}/${VERSION_CODENAME}"
else
    BRANCH="debian/sid"
fi
BINARY_ONLY=""
git clone -b ${BRANCH} https://github.com/openwebrx/SoapyFCDPP-debian
pushd SoapyFCDPP-debian
if [[ ! -z ${BUILD_NUMBER:-} ]]; then
  GBP_ARGS="--debian-branch=${BRANCH} --snapshot --auto --snapshot-number=${BUILD_NUMBER}"
  gbp dch ${GBP_ARGS}
  git add debian/changelog
  git commit -m "snapshot changelog"
  # NOTE: -b builds only binaries, no source package.
  # we enable this here because there's a number of changes in git that have not been part of a release so far.
  # this is ok for snapshot builds, but for the release packages it would be nice to have a new release tag.
  BINARY_ONLY="-b"
fi
gbp buildpackage --git-debian-branch=${BRANCH} --git-submodules -us -uc ${BINARY_ONLY}
popd