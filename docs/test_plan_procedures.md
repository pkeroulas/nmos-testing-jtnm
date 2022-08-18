# Test plan procedure

### 1. Get the initial UUIDs of the DuT

In Main environement, execute [this script](https://github.com/AMWA-TV/nmos-testing/tree/master/utilities/uuid-checker)
to fetch orginal UUIDs.

### 2. Move the DuT from Main to NMOS env

Enter the switch connected the DuT and [change the port config](../docs/arista_cmd_helper.md#move-an-endpoint-to-the-nmos-test-environment).

### 3. IP validation

* Test plan A.1.1:
2 ways for finding the DutT IP(s) from its MAC address(es):
- `./dhcp/dhcp.leases` is written by the DHCP server to reflect the current leases.
- show the ouput put of the dhcp container `docker-compose log -f | grep dhcp`

MAC also be found by [browsing the switch ARP table](../docs/arista_cmd_helper.md#display-the-arp-table).

### 4. LLDP validation

* Test plan A.1.2
Enter the switch connected the DuT and [show the LLDP info](../docs/arista_cmd_helper.md#display-the-lldp-chassis-id-and-port-id)

### 5. Verify the consistency UUIDs in NMOS test environment

* Test plan A.3.6:
Reuse [the uuid checker](https://github.com/AMWA-TV/nmos-testing/tree/master/utilities/uuid-checker).
After the test is performed, remove or rename `uuids.json`.

### 6. Perform the NMOS-testing test(s)

[Grid for quick view.](https://specs.amwa.tv/nmos-testing/)

Download the result files and copy into the [private repo](https://github.com/rbgodwin-nt/jt-nm-tested-2022).

### 8. Restore the DuT in Main env

Enter the switch connected the DuT and [restore the port config](../docs/arista_cmd_helper.md#move-an-endpoint-to-the-nmos-test-environment).

### 9. Stream/SDP validation

* Test A.5.1/2:
This one can be performed in Main env with reference senders and receivers.
Specific [IS-05 script](https://github.com/pkeroulas/nmos-testing/tree/improve-is-05-control/utilities/is-05-control) is required.

* Test A.5.3: mcast and igmp
[Check the mcast routes on the switch](../docs/arista_cmd_helper.md#display-mcast-and-igmp).

* Test A.5.4: the SDP from A.5.1/2 should include the source IP filter
