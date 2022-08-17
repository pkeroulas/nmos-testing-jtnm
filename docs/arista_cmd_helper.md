# Arista switch command helper

First step: login the switch with ssh.

Note that it is possible to `| grep [-C ...] <string>` the cmd result.

## Move an endpoint to the NMOS test environment

Example: Let's take a device whose mgt port is plugged to the switch port #10.
And let's move it to NMOS env #2 by _changing the VLAN inside the switch
port config (layer 2)_. To do so, check and use the aliases:

```
alias mgt2nmos2
 1 conf
 2 interface ethernet %1
 3 no switchport access vlan 1001
 4 no switchport access vlan 2001
 5 switchport access vlan 2002
 6 no switchport access vlan 2003
 7 show active
 8 end
mgt2nmos2 10
[...]
# TO REVERT:::::::
mgt2main 10
```

For _devices whose mgt/nmos interface is embedded in the media port, the
switch port config is layer 3 and VLAN can't be applied_.
The `media2nmos*` aliases works by changing the `ip helper-address` to
point at the DHCP server of the NMOS-testing env.

```
alias media2nmos2
 1 conf
 2 interface ethernet %1
 3 no ip helper 192.168.0.20
 4 no ip helper 192.168.204.20
 5 ip helper 192.168.208.20
 6 no ip helper 192.168.212.20
 7 show active
 8 end
media2nmos2 10
[...]
# TO REVERT:::::::
media2main 10
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

## Display mcast and igmp

Show an existing multicast and verify the source IP, the ingress and outgress ports:

```
#show ip mroute 239.80.2.2
[...]
239.80.2.2
  10.164.32.73, 23:54:24, flags: SLP
    Incoming interface: Ethernet19
    RPF route: [U] 10.164.32.72/30 [0/0]
    Outgoing interface list:
      Ethernet17
```

Show the group membership, and verify the source IP filtering for the subscriber (IGMP v3):

```
show ip igmp membership group 239.80.2.2
Interface----------------Group Address----IncludeSrc----------ExcludeSrc----------
Ethernet17               239.80.2.2       10.164.32.73
```

## Create a monitor session to show the network traffic

[rtcpdump](https://github.com/pkeroulas/st2110-toolkit/blob/master/capture/rtcpdump.sh)
automates the monitor session and forwards packets to your desktop `wireshark.`
