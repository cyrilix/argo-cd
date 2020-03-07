#!/bin/bash
set -eux -o pipefail

TARGETPLATFORM=$1

if [[ -z "${TARGETPLATFORM}" ]]
then
  TARGETPLATFORM="linux/amd64"
fi

OS=$(echo $TARGETPLATFORM | cut -f1 -d/)
ARCH=$(echo $TARGETPLATFORM | cut -f2 -d/)
ARM=$(echo $TARGETPLATFORM | cut -f3 -d/ | sed "s/v//" )

KUSTOMIZE_VERSION=${KUSTOMIZE_VERSION:-3.2.1}


GOPATH=/tmp/go
mkdir -p ${GOPATH}/src
set +e
git clone https://github.com/kubernetes-sigs/kustomize.git
set -e

cd kustomize/kustomize
git checkout kustomize/v${KUSTOMIZE_VERSION}

echo "Build ${ARCH} binary"
GO111MODULE=on GOARCH=${ARCH} GOOS=${OS} GOARM=${ARM} go build

mv kustomize ${BIN}/kustomize
chmod +x $BIN/kustomize

kustomize version
