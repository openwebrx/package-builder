#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)

for DIST in `cat dists/$ARCH`; do
    TAG=${DIST//[:]/_}_${ARCH}
    BASE_TAG=${TAG}_base
    STAGING_TAG=${TAG}_staging
    LATEST_TAG=${TAG}_latest

    docker build --pull --build-arg BASE=${DIST} -f docker/Dockerfile-base-debian -t package-builder:${BASE_TAG} .

    docker build --build-arg BASE_TAG=${BASE_TAG} -f docker/Dockerfile-staging-debian -t 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${STAGING_TAG} .
    docker push 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${STAGING_TAG}

    docker build --build-arg BASE_TAG=${BASE_TAG} -f docker/Dockerfile-latest-debian -t 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${LATEST_TAG} .
    docker push 768356633999.dkr.ecr.eu-central-1.amazonaws.com/package-builder:${LATEST_TAG}
done
