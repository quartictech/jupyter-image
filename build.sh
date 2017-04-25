#! /bin/bash
set -eu

# TODO: inject ${VERSION} into setup.py somehow
VERSION=${CIRCLE_BUILD_NUM-unknown}
QUARTIC_DOCKER_REPOSITORY=${QUARTIC_DOCKER_REPOSITORY-quartic}

docker build -t ${QUARTIC_DOCKER_REPOSITORY}/taijitu:${VERSION} .
docker push ${QUARTIC_DOCKER_REPOSITORY}/taijitu:${VERSION}
