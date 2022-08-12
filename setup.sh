#!/bin/bash

echo "---------------------------------------------"
echo "           Populate conf with"
echo "---------------------------------------------"
source .env

SUBNET=${SUBNET_PREFIX}.0
GATEWAY_IP=${SUBNET_PREFIX}.1
DHCP_IP=${SUBNET_PREFIX}.2
TEST_TOOL_IP=${SUBNET_PREFIX}.3

echo "Interface:          $IFACE"
echo "Subnet:             $SUBNET"
echo "Gateway:            $GATEWAY_IP"
echo "Nmos-testing + DNS: $TEST_TOOL_IP"
echo "Dhcp server:        $DHCP_IP"

echo "---------------------------------------------"
echo "           dhcpd:"
echo "---------------------------------------------"
sed -i "\
s,\(^option domain-name-servers\).*;,\1 $TEST_TOOL_IP;,;
s,\(^subnet\) .* \(netmask 255.255.255.0 {\),\1 $SUBNET \2,;
s,\(    option broadcast-address\).*;,\1 $SUBNET_PREFIX.255;,;
s,\(    option routers\).*;,\1 $GATEWAY_IP;,;
s,\(    range\).*;,\1 $SUBNET_PREFIX.5 $SUBNET_PREFIX.99;,
" ./dhcp/dhcpd.conf
cat ./dhcp/dhcpd.conf

echo "---------------------------------------------"
sed -i "s,\(CONFIG.DNS_UPSTREAM_IP =\).*,\1 '$GATEWAY_IP'," ./UserConfig.py
