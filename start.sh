#!/bin/bash

if [[ ! -f /var/run/.stamp_installed ]]; then
  if [[ -z "${BIND9_ROOTDOMAIN}" ]];then
    echo "The variable BIND9_ROOTDOMAIN must be set"
    exit 1
  fi
  echo "Creating named configuration"
  cat <<EOF > /etc/bind/named.conf.local
zone "${BIND9_ROOTDOMAIN}" {
       type master;
       file "/etc/bind/zones/db.${BIND9_ROOTDOMAIN}";
       allow-update { any; } ;
};
EOF
  echo "Creating ${BIND9_ROOTDOMAIN} configuration"
  cat <<EOF >> "/etc/bind/zones/db.${BIND9_ROOTDOMAIN}" 
@		IN SOA	ns.${BIND9_ROOTDOMAIN}. root.${BIND9_ROOTDOMAIN}. (
				20041125   ; serial
				604800     ; refresh (1 week)
				86400      ; retry (1 day)
				2419200    ; expire (4 weeks)
				604800     ; minimum (1 week)
				)
			NS	ns.${BIND9_ROOTDOMAIN}.
ns			A	127.0.0.1
EOF
  chown -R bind:bind /etc/bind/zones/
  touch /var/run/.stamp_installed
fi

named -g -c /etc/bind/named.conf -u bind
