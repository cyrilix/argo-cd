#!/bin/bash
set -eux -o pipefail

. $(dirname $0)/../tool-versions.sh

TARGETPLATFORM=$1

if [[ -z "${TARGETPLATFORM}" ]]
then
  TARGETPLATFORM="linux/amd64"
fi

OS=$(echo $TARGETPLATFORM | cut -f1 -d/)
ARCH=$(echo $TARGETPLATFORM | cut -f2 -d/)
ARM=$(echo $TARGETPLATFORM | cut -f3 -d/ | sed "s/v//" )

KUSTOMIZE_VERSION=${KUSTOMIZE_VERSION:-$kustomize3_version}

GOPATH=/tmp/go
mkdir -p ${GOPATH}/src
set +e
git clone https://github.com/kubernetes-sigs/kustomize.git
set -e

cd kustomize/kustomize
git checkout kustomize/v${KUSTOMIZE_VERSION}

GOPATH=/tmp/go
mkdir -p ${GOPATH}/src
set +e
git clone https://github.com/kubernetes-sigs/kustomize.git
set -e

cd kustomize/kustomize
git checkout kustomize/v${KUSTOMIZE_VERSION}

echo "Build ${ARCH} binary"
BINNAME=kustomize
GO111MODULE=on GOARCH=${ARCH} GOOS=${OS} GOARM=${ARM} go build

mv kustomize ${BIN}/${BINNAME}
chmod +x $BIN/$BINNAME

$BINNAME version
