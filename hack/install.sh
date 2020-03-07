#!/bin/bash
set -eux -o pipefail

export DOWNLOADS=/tmp/dl
export BIN=${BIN:-/usr/local/bin}

mkdir -p $DOWNLOADS

"$(dirname $0)/installers/install-$1.sh" $2
