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

AWS_IAM_AUTHENTICATOR_VERSION=0.4.0-alpha.1

git clone https://github.com/kubernetes-sigs/aws-iam-authenticator.git
cd aws-iam-authenticator
git checkout "${AWS_IAM_AUTHENTICATOR_VERSION}"
GO111MODULE=on GOARCH=${ARCH} GOOS=${OS} GOARM=${ARM} go build ./cmd/aws-iam-authenticator

mv aws-iam-authenticator $BIN
chmod +x $BIN/aws-iam-authenticator
aws-iam-authenticator version