#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)

for DIST in `cat dists/$ARCH`; do
    TAG=${DIST//[:]/_}_${ARCH}
    STABLE_TAG=${TAG}_stable
    LATEST_TAG=${TAG}_latest

    docker build --pull --build-arg BASE=${DIST} -f docker/Dockerfile-stable-debian -t 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${STABLE_TAG} .
    docker push 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${STABLE_TAG}

    docker build --pull --build-arg STABLE_TAG=${STABLE_TAG} -f docker/Dockerfile-latest-debian -t 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${LATEST_TAG} .
    docker push 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${LATEST_TAG}
done
