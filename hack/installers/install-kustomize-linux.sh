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

KUSTOMIZE_VERSION=${KUSTOMIZE_VERSION:-3.2.0}
DL=$DOWNLOADS/kustomize-${KUSTOMIZE_VERSION}

# Note that kustomize release URIs have changed for v3.2.1. Then again for
# v3.3.0. When upgrading to versions >= v3.3.0 please change the URI format. And
# also note that as of version v3.3.0, assets are in .tar.gz form.
# v3.2.0 = https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64
# v3.2.1 = https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.2.1/kustomize_kustomize.v3.2.1_linux_amd64
# v3.3.0 = https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz
case $KUSTOMIZE_VERSION in
  2.*)
    URL=https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_${OS}_${ARCH}
    ;;
  *)
    URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_kustomize.v${KUSTOMIZE_VERSION}_${OS}_${ARCH}
    ;;
esac

if [[ "${ARCH}" == "amd64" ]] ; then

[ -e $DL ] || curl -sLf --retry 3 -o $DL $URL
cp $DL $BIN/kustomize
chmod +x $BIN/kustomize
kustomize version

else

  GOPATH=/tmp/go
  set +e
  go get github.com/kubernetes-sigs/kustomize
  set -e
  cd ${GOPATH}/src/github.com/kubernetes-sigs/kustomize
  git checkout v${KUSTOMIZE_VERSION}
  echo "Build ${ARCH} binary"
  GOARCH=${ARCH} GOOS=${OS} GOARM=${ARM} go build ./cmd/kustomize
  mv kustomize ${BIN}/kustomize
  chmod +x $BIN/ks
  ks version

fi