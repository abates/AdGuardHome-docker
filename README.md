# AdGuardHome-docker

This docker image is based on the official AdGuard Home Docker image.  The 
difference is that when this image starts a dnsmasq instance is started
and the AdGuard upstream servers are set to the dnsmasq instance.

### Usage

In order to use this image, dnsmasq configs must be provided using a bind mount
to /etc/upstream.d.  Here is an example:

```shell
docker run --cap-add NET_ADMIN --rm --volume=$(pwd)/upstream.d:/etc/upstream.d abates314/adguardhome
```

### Upstream DNS

To set the upstream DNS servers for the dnsmasq instance use the DNS1 and DNS2 
docker environment variables:

```
docker run --cap-add NET_ADMIN --rm -e DNS1=208.67.222.123 -e DNS2=208.67.220.123 abates314/adguardhome
```

