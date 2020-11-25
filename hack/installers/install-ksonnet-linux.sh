#!/bin/bash
set -eux -o pipefail

. $(dirname $0)/../tool-versions.sh
KSONNET_VERSION=${ksonnet_version}

if [[ -z "${TARGETPLATFORM}" ]]
then
  TARGETPLATFORM="linux/amd64"
fi

OS=$(echo $TARGETPLATFORM | cut -f1 -d/)
ARCH=$(echo $TARGETPLATFORM | cut -f2 -d/)
ARM=$(echo $TARGETPLATFORM | cut -f3 -d/ | sed "s/v//" )

if [[ "${ARCH}" == "amd64" ]] ; then

  [ -e $DOWNLOADS/ks.tar.gz ] || curl -sLf --retry 3 -o $DOWNLOADS/ks.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v${KSONNET_VERSION}/ks_${KSONNET_VERSION}_${OS}_${ARCH}.tar.gz
  tar -C /tmp -xf $DOWNLOADS/ks.tar.gz
  cp /tmp/ks_${KSONNET_VERSION}_${OS}_${ARCH}/ks $BIN/ks

  chmod +x $BIN/ks

else
    GOPATH=/tmp/go
    set +e
    go get github.com/ksonnet/ksonnet
    set -e
    cd ${GOPATH}/src/github.com/ksonnet/ksonnet
    ls
    git checkout v${KSONNET_VERSION}
    echo "Build ${ARCH} binary"
    GOARCH=${ARCH} GOOS=${OS} GOARM=${ARM} make install && mv ${GOPATH}/bin/ks ${BIN}/ks
    chmod +x $BIN/ks
fi

ks version
