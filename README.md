docker-bind9 
================
This project build a bind9 domain name server configured to serve and accept updates for the root domain $BIND9_ROOTDOMAIN env variable.

Use the following ENV when running :

- "BIND9_IP" : public IP of the DNS
- "BIND9_ROOTDOMAIN" : the root domain (like : example.com)
- "BIND9_KEYNAME" : the name of the key
- "BIND9_KEY" : the key base64 encoded
- "BIND9_KEY_ALGORITHM" : the key algo - examples : hmac-md5, hmac-sha1, hmac-sha256, hmac-sha512
- "BIND9_FORWARDERS" : the forwarders (like : 8.8.8.8;8.8.8.4;)
- "BIND9_IPV4ONLY" : set bind9 to support only IPV4
- "BIND9_QUERY_CACHE_ACCEPT": set IP to allow in allow-query-cache, default 127.0.0.1. (use 10.0.0.0/8 for any local ip)
- "BIND9_RECURSION_ACCEPT": set IP to allow in allow-recursion, default 127.0.0.1. (use 10.0.0.0/8 for any local ip)
- "BIND9_STATIC_ENTRIES": multiline static entries for your zone.

The port 53 must be exposed in tcp and udp to answer DNS requests. The server will accept any query, but no cache request or recursion (the variable are set to listen 127.0.0.1 only by default)

Run with :

```bash

# With Forwarders: Bind ports to local docker IP to reduce forwarding risk
sudo docker run --name bind9 --restart=unless-stopped \
    -e "BIND9_IP=10.10.12.23" \
    -e "BIND9_ROOTDOMAIN=example.com" \
    -e "BIND9_KEYNAME=secret" \
    -e "BIND9_KEY_ALGORITHM=hmac-md5" \
    -e "BIND9_KEY=c2VjcmV0" \
    -e "BIND9_FORWARDERS=8.8.8.8;8.8.4.4;" \
    -p "172.17.0.1:53:53/udp" \
    -p "172.17.0.1:53:53" digitallumberjack/docker-bind9:latest

# No Forwarders - Only For Authority
sudo docker run --name bind9 --restart=unless-stopped \
    -e "BIND9_IP=10.10.12.23" \
    -e "BIND9_ROOTDOMAIN=example.com" \
    -e "BIND9_KEYNAME=secret" \
    -e "BIND9_KEY_ALGORITHM=hmac-md5" \
    -e "BIND9_KEY=c2VjcmV0" \
    -e "BIND9_FORWARDERS=" \
    -p 53:53/udp \
    -p 53:53 digitallumberjack/docker-bind9:latest

# With static entries
sudo docker run --name bind9 --restart=unless-stopped \
    -e "BIND9_IP=10.10.12.23" \
    -e "BIND9_ROOTDOMAIN=example.com" \
    -e "BIND9_KEYNAME=secret" \
    -e "BIND9_KEY_ALGORITHM=hmac-md5" \
    -e "BIND9_KEY=c2VjcmV0" \
    -e "BIND9_FORWARDERS=" \
    -e BIND9_STATIC_ENTRIES="www CNAME a.fqdn.com
blog 60 A 10.10.10.10" \
    -p 53:53/udp \
    -p 53:53 digitallumberjack/docker-bind9:latest

```

To manually add an entry :
```
nsupdate -y secret:c2VjcmV0
server 10.10.12.23
update add myentry.example.com 60 A 10.10.14.100
```

To get all entries of a domain with axfr request:
```
dig -y secret:c2VjcmV0 @10.10.12.23 example.com axfr
```


See nsupdate man for usage.
