#!/bin/bash
set -eux -o pipefail

if [[ -z "${TARGETPLATFORM}" ]]
then
  TARGETPLATFORM="linux/amd64"
fi

OS=$(echo $TARGETPLATFORM | cut -f1 -d/)
ARCH=$(echo $TARGETPLATFORM | cut -f2 -d/)
ARM=$(echo $TARGETPLATFORM | cut -f3 -d/ | sed "s/v//" )

if [[ "${ARCH}" == "amd64" ]] ; then

[ -e $DOWNLOADS/ks.tar.gz ] || curl -sLf --retry 3 -o $DOWNLOADS/ks.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v0.13.1/ks_0.13.1_${OS}_${ARCH}.tar.gz
tar -C /tmp -xf $DOWNLOADS/ks.tar.gz
cp /tmp/ks_0.13.1_linux_amd64/ks $BIN/ks
chmod +x $BIN/ks
ks version

else
    GOPATH=/tmp/go
    KSONNET_VERSION=0.13.1
    set +e
    go get github.com/ksonnet/ksonnet
    set -e
    cd ${GOPATH}/src/github.com/ksonnet/ksonnet
    ls
    git checkout v${KSONNET_VERSION}
    echo "Build ${ARCH} binary"
    GOARCH=${ARCH} GOOS=${OS} GOARM=${ARM} make install && mv ${GOPATH}/bin/ks ${BIN}/ks
    chmod +x $BIN/ks
    ks version

fi