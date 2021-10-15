FROM golang:alpinet3.14 AS builder

ARG BUILDPLATFORM
ARG TARGETARCH
ARG ADGUARD_VERSION=v0.107.0-b.13

WORKDIR /go/src
RUN apk update && \
    apk upgrade && \
    apk add git make nodejs npm && \
    npm install --global yarn 

RUN git clone https://github.com/AdguardTeam/AdGuardHome.git adguard && \
    cd adguard && \
    git -c advice.detachedHead=false checkout tags/$ADGUARD_VERSION

# Such a hack :-/
WORKDIR /go/src/adguard
RUN sed -e 's;https://dns10.quad9.net/dns-query;127.0.0.1:5300;' -i /go/src/adguard/internal/dnsforward/dnsforward.go && \
    make

FROM alpine:3.14

ARG BUILDPLATFORM
ARG TARGETARCH

ADD download.sh /tmp

RUN apk update && \
    apk upgrade && \
    apk add --update ca-certificates libcap tzdata

RUN /tmp/download.sh && \
    tar xzf /tmp/s6overlay.tar.gz -C / && \
    rm /tmp/s6overlay.tar.gz

RUN apk add dnsmasq-dnssec

RUN mkdir -p /opt/adguardhome/conf /opt/adguardhome/work && \
    chown -R nobody: /opt/adguardhome && \
    rm -rf /var/cache/apk/* 


COPY root/ /
COPY --from=builder /go/src/adguard/AdGuardHome /opt/adguardhome/AdGuardHome

RUN setcap 'cap_net_bind_service=+eip' /opt/adguardhome/AdGuardHome

# 53     : TCP, UDP : DNS
# 67     :      UDP : DHCP (server)
# 68     :      UDP : DHCP (client)
# 80     : TCP      : HTTP (main)
# 3000   : TCP, UDP : HTTP(S) (alt, incl. HTTP/3)
EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 3000/tcp 3000/udp

VOLUME ["/etc/upstream"]
VOLUME ["/etc/upstream.d"]

ENTRYPOINT ["/init"]

