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


[ -e $DOWNLOADS/helm2.tar.gz ] || curl -sLf --retry 3 -o $DOWNLOADS/helm2.tar.gz https://get.helm.sh/helm-v2.15.2-${OS}-${ARCH}.tar.gz
mkdir -p /tmp/helm2 && tar -C /tmp/helm2 -xf $DOWNLOADS/helm2.tar.gz
cp /tmp/helm2/${OS}-${ARCH}/helm $BIN/helm2

helm2 version --client
