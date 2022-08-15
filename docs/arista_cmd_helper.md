# Arista switch command helper

First step: login the switch with ssh.

Note that it is possible to `| grep [-C ...] <string>` the cmd result.

## Move an endpoint to the NMOS test environment

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

## Display the LLDP Chassis ID and Port ID

Each vendor will provide their ports or MAC for both management and
media interface. Then the Arista switch can provide the LLDP table:

```
show lldp neighbors
Port          Neighbor Device ID                   Neighbor Port ID    TTL
---------- ------------------------------------ ---------------------- ----
[...]
Et10          <DuT's Chassis ID or System Name>    <MAC or Port Name>  120
[...]
```

and details like Chassis ID:

```
show lldp neighbors Et10 detail
Interface Ethernet38 detected 1 LLDP neighbors:
  Neighbor xxxx.xxxx.xxxx/xxxx.xxxx.xxxx, age 82 seconds
  Discovered 6 days, 11:24:04 ago; Last changed 6 days, 11:24:04 ago
  - Chassis ID type: MAC address (4)
    Chassis ID     : xxxx.xxxx.xxxx
  - Port ID type: MAC address(3)
    Port ID     : xxxx.xxxx.xxxx
[...]
```

## Display the ARP table

```
show arp mac xxxx.xxxx.xxxx
Address         Age (sec)  Hardware Addr   Interface
XXX.XXX.XXX.XXX 0:00:03    xxxx.xxxx.xxxx  Ethernet10
```

## Create a monitor session to show the network traffic

[rtcpdump](https://github.com/pkeroulas/st2110-toolkit/blob/master/capture/rtcpdump.sh)
automates the monitor session and forwards packets to your desktop `wireshark.`
