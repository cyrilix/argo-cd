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

# NOTE: keep the version synced with https://storage.googleapis.com/kubernetes-release/release/stable.txt
[ -e $DOWNLOADS/kubectl ] || curl -sLf --retry 3 -o $DOWNLOADS/kubectl https://storage.googleapis.com/kubernetes-release/release/v${kubectl_version}/bin/${OS}/${ARCH}/kubectl
cp $DOWNLOADS/kubectl $BIN/
chmod +x $BIN/kubectl
