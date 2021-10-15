#!/bin/ash

# Download the S6 overlay
if [[ "$TARGETARCH" == "386" ]] ; then S6ARCH="x86" ; else S6ARCH="$TARGETARCH" ; fi
S6_OVERLAY_RELEASE="https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-$S6ARCH.tar.gz"
echo "Downloading $S6_OVERLAY_RELEASE"
wget -O /tmp/s6overlay.tar.gz "${S6_OVERLAY_RELEASE}"

# Download YQ
YQ_VERSION=v4.13.4
YQ_BINARY=yq_linux_${TARGETARCH}
wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}.tar.gz -O - | tar xz && mv ${YQ_BINARY} /usr/bin/yq
