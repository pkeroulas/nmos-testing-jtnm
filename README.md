# NMOS-TESTING reference testbed for JT-NM

Based on [Easy-NMOS](https://github.com/rhastie/easy-nmos) + DHCP server - registry

Preriquisites:
* docker version 20.10.12
* docker-compose version 1.29.2

## Config

_Constants:_

* discovery method: unicast DNS-SD
* domain: `nmos-testing.jt-nm.org`
* /24 subnet

_Variables:_

Edit `.env` to supply the subnet and the network interface.
And execute `setup.conf` that modifies `./dhcp/dhcpd.conf` and
`UserConfig.py`:

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

## MISC

* [Test plan procedures](./docs/test_plan_procedures.md)
* [Arista cmd helper](./docs/arista_cmd_helper.md)
* `./nmos-cpp` can be used for easy testing but the config needs to be
  ajusted
