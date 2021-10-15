#FROM golang:alpine3.12 AS builder

FROM adguard/adguardhome:latest

ARG BUILDPLATFORM
ARG TARGETARCH

ADD download.sh /tmp

RUN apk update && \
    apk upgrade && \
    /tmp/download.sh && \
    tar xzf /tmp/s6overlay.tar.gz -C / && \
    rm /tmp/s6overlay.tar.gz && \
    apk add dnsmasq-dnssec

COPY root/ /

VOLUME ["/etc/upstream"]
VOLUME ["/etc/upstream.d"]

ENTRYPOINT ["/init"]

