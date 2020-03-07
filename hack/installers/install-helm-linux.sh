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


[ -e $DOWNLOADS/helm.tar.gz ] || curl -sLf --retry 3 -o $DOWNLOADS/helm.tar.gz https://get.helm.sh/helm-v2.15.2-${OS}-${ARCH}.tar.gz
tar -C /tmp/ -xf $DOWNLOADS/helm.tar.gz
cp /tmp/helm/${OS}-${ARCH}/helm $BIN/helm
helm version --client
