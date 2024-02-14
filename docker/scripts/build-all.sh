#!/usr/bin/env bash
set -euo pipefail

mkdir -p /tmp/output
mkdir -p /tmp/build
cd /tmp/build

ARCH=$(uname -m)

PACKAGES=$(cd /packages && ls -d *)
if [[ ! -z "${1:-}" ]]; then
    PACKAGES=$(cd /packages && ls -d ??-${1})
fi
echo "package list: ${PACKAGES}"

DEPS=""
for PACKAGE in ${PACKAGES}; do
    if [[ -e /packages/${PACKAGE}/dynamic-build-depends ]]; then
        DEPS="${DEPS} $(cat /packages/${PACKAGE}/dynamic-build-depends)"
    fi
    if [[ -e /packages/${PACKAGE}/dynamic-build-depends.${ARCH} ]]; then
        DEPS="${DEPS} $(cat /packages/${PACKAGE}/dynamic-build-depends.${ARCH})"
    fi
done

if [[ ! -z "${DEPS// /}" ]]; then
    apt-get update && apt-get install -y --no-install-recommends ${DEPS}
fi

for PACKAGE in ${PACKAGES}; do
    echo "Building package $PACKAGE"
    /packages/$PACKAGE/build.sh

    if ls *.deb; then
        dpkg -i *.deb
        for DEB in `ls *.deb`; do
            mv $DEB /tmp/output
        done
    fi

    if ls *.ddeb; then
        dpkg -i *.ddeb
        for DEB in `ls *.ddeb`; do
            mv $DEB /tmp/output
        done
    fi
done

export GPG_TTY=$(tty)
gpg --batch --import <(echo "$SIGN_KEY")

cd /tmp/output

for PACKAGE in `ls *.deb`; do
    debsigs --sign=maint -k $SIGN_KEY_ID $PACKAGE
done

for PACKAGE in `ls *.ddeb`; do
    debsigs --sign=maint -k $SIGN_KEY_ID $PACKAGE
done

tar cvfz /packages.tar.gz *.deb *.ddeb