# NMOS-TESTING reference testbed for JT-NM

Based on [Easy-NMOS](https://github.com/rhastie/easy-nmos) + DHCP server - registry

Preriquisites:
* docker version 20.10.12
* docker-compose version 1.29.2

## Config

### Constants:

* discovery method: unicast DNS-SD
* domain: `testsuite.nmos.tv`
* /24 subnet

### Variables:

Edit `.env` to supply the subnet and the network interface.
And execute the script that modifies `./dhcp/dhcpd.conf` and
`UserConfig.py`.

```
cat .env
SUBNET_PREFIX=192.168.6
IFACE=eno2
./setup.sh
```

## Start

```
docker-compose up -d
docker-compose logs -f --tail=50
[...]
Ctrl+C
docker=compose down
```

Note that `./dhcp/dhcp.leases` is written by the DHCP server to reflect
the current leases.

## Arista switch operations

First step: login the switch with ssh.

### Move an endpoint to the NMOS test environment

Take the ethernet port #10 for instance:

```
conf
(config)#interface ethernet 10
(config-if-Et10)#switchport access vlan [VLAN-ID]
(config-if-Et10)#show active
interface Ethernet10
   description My endpoint to be tested
   switchport access vlan [VLAN-ID]
(config-if-Et10)#exit
```

To switch back to the `Main` env, add `no`.

```
(config-if-Et10)#no switchport access vlan [VLAN-ID]
```

### Display the LLDP table

```
show lld neighbors
Port          Neighbor Device ID                   Neighbor Port ID    TTL
---------- ------------------------------------ ---------------------- ----
Et10          My endpoint to be tested             xxxx.xxxx.xxxx      120
[...]
```

`Neighport Port ID` is sometimes the MAC address.

### Display the ARP-IP-MAC table

```
show arp
Address         Age (sec)  Hardware Addr   Interface
XXX.XXX.XXX.XXX 0:00:03    xxxx.xxxx.xxxx  Ethernet10
[...]
```

### Create a monitor session to show the network traffic

[rtcpdump](https://github.com/pkeroulas/st2110-toolkit/blob/master/capture/rtcpdump.sh)
automates the monitor session and forwards packets to your desktop `wireshark.`
