#!/bin/bash

echo "---------------------------------------------"
echo "           Populate conf with"
echo "---------------------------------------------"
cat .env
source .env

echo "---------------------------------------------"
echo "           dhcpd:"
echo "---------------------------------------------"
sed -i "\
s,\(^option domain-name-servers\).*;,\1 $TEST_TOOL_IP;,;
s,\(^subnet\) .* \(netmask 255.255.255.0 {\),\1 $SUBNET_PREFIX.0 \2,;
s,\(    option broadcast-address\).*;,\1 $SUBNET_PREFIX.255;,;
s,\(    option routers\).*;,\1 $GATEWAY_IP;,;
s,\(    range\).*;,\1 $SUBNET_PREFIX.10 $SUBNET_PREFIX.99;,
" ./dhcp/dhcpd.conf
cat ./dhcp/dhcpd.conf

echo "---------------------------------------------"
sed -i "s,\(CONFIG.DNS_UPSTREAM_IP = \).*,\1 '$GATEWAY_IP'," ./UserConfig.py
