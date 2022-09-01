# Test plan procedure

### 0. Get info from the vendor

For management interface:
- switch port num
- mac address
- IP address

IPAM for media interfaces is detailed in the master spreadsheet.

### 1. Get the initial UUIDs of the DuT

In Main environement, execute [this script](https://github.com/AMWA-TV/nmos-testing/tree/master/utilities/uuid-checker)
to fetch orginal UUIDs. You may have to execute from your workstation to
access Main env.


### 2. Move the DuT from Main to NMOS env

This step consists in exposing our DHCP to provide DNS and NTP to the
Dut. DNS will then help testing unicast DNS-SD.

Enter the switch connected the DuT and [change the port config](../docs/arista_cmd_helper.md#move-an-endpoint-to-the-nmos-test-environment).
(media only if dns-sd dicscovery is supported because the /30 address
are routed so thay can access anything)

Ask the vendor for a DuT reboot.

### 3. IP validation

* Test plan A.1.1:
2 ways for finding the DutT IP(s) from its MAC address(es):
- `./dhcp/dhcp.leases` is written by the DHCP server to reflect the current leases.
- show the ouput put of the dhcp container `docker-compose log -f | grep dhcp`

MAC also be found by [browsing the switch ARP table](../docs/arista_cmd_helper.md#display-the-arp-table).

### 4. LLDP validation

* Test plan A.1.2
Enter the management switch connected the DuT and [show the LLDP info](../docs/arista_cmd_helper.md#display-the-lldp-chassis-id-and-port-id)
Repeat with media swith(es).

### 5. Verify the consistency UUIDs in NMOS test environment

* Test plan A.3.6:
Reuse [the uuid checker](https://github.com/AMWA-TV/nmos-testing/tree/master/utilities/uuid-checker).
After the test is performed, remove or rename `uuids.json`.

### 6. Perform the NMOS-testing test(s)

[Grid for quick view.](https://specs.amwa.tv/nmos-testing/)

MAKE SURE there is no rogue node or registry that could interfer with the test.

* `IS-04-01`
If dns-sd isn't supported: the node under test should register using port 5101.


* `IS-04 registry APIs`
Before running the test, a node (with resources should run and register
to the RuT) and a client should create a ws subscription:
`curl --cacert test_data/BCP00301/ca/certs/ca.cert.pem "http://<IP:port>/x-nmos/query/v1.3/subscriptions" -H "Content-Type: application/json" -d "{\"max_update_rate_ms\": 100, \"resource_path\": \"/nodes\", \"params\": {\"label\": \"host1\"}, \"persist\": true, \"secure\": false}" -s`

* `IS-08 Channel Mapping`
Open the URL for the Device in the browser e.g. http://<IP>/x-nmos/channelmapping/v1.0/inputs/input0/properties/
Verify the name and description are readable by a human

* Results
Download the json files and copy into the [private repo](https://github.com/rbgodwin-nt/jt-nm-tested-2022).
It is organized by folder structure: `tested/<vendor>/<device>`
The json have to be zipped and named `<vendor>.<device>.zip`

### 8. Restore the DuT in Main env

Enter the switch connected the DuT and [restore the port config](../docs/arista_cmd_helper.md#move-an-endpoint-to-the-nmos-test-environment).

### 9. Stream/SDP validation

* Test A.5.1/2:
This one can be performed in Main env with reference senders and receivers.
Specific [IS-05 script](https://github.com/pkeroulas/nmos-testing/tree/improve-is-05-control/utilities/is-05-control) is required. or just use Riedel NMOS explorer.


* Test A.5.3: mcast and igmp
[Check the mcast routes on the switch](../docs/arista_cmd_helper.md#display-mcast-and-igmp).

* Test A.5.4: the SDP from A.5.1/2 should include the source IP filter (receivers)
Download the SDP from the senders, edit the source IP manually push the
fake SDP to the sender. The receiver should not subscribre to the multicast.
