# RemotiveBroker bootstrapped
## Run it yourself

Remotive Labs provides integrations to various platforms, however in many cases 
you like to need the host of your choice. If so; you are in the correct location, 
keep reading.

prerequisites:
- `docker` 
- `docker-compose`
- `git` 
- `inotify-tools` (optional)

### Step 1/2 start docker 

Clone this repository and make sure you have `docker` and `docker-compose`
installed, then run:

```bash
docker-compose up -d
```

This command only needs to be run once. It is persistent over system reboot --
the containers will be restarted after a reboot, over and over again.

Point your web browser at the machine running RemotiveBroker, an address like
`http://192.0.2.42:8080/`. 


**Please note**, *the following license applies to the usage of Remotive Labs products, which is also shown when you run `docker-compose up` in attached mode.*
```
##########################################################################################
      You are using software provided by Remotive Labs AB pursuant to the
      terms of the End User License Agreement located at
      https://www.remotivelabs.com/license. This license sets out the only
      licensed rights granted to you with respect to this software.
      By downloading or using such software, you accept and agree to the
      terms of his license. This license is valid until 'your end date will be shown here'.
      After this date, you need to either renew your license or cease
      all use of the software.
##########################################################################################
```

**DONE**! Now improve your experience by applying next step. 


### Step 2/2 (optional, quality of life improvement) Upgrade through the web interface

In order to allow upgrades triggered by the user interface you need to install a 
custom service. To install and start this service (only needed once):

```bash
sudo scripts/install-service.sh
```

> This script assumes that you are running on a host where `systemd` is present 

## Custom can interfaces

RemotiveBroker support all can interfaces which supports `socket-can`. Many USB 
can connectors are supported by default by the linux kernel. Typically it will appear
when you do `ip a` then you simply need to do:
```bash
#can/canfd
ip link set can0 type can bitrate 500000 dbitrate 2000000 restart-ms 1000 berr-reporting on fd on
#can
ip link set can0 type can bitrate 500000 dbitrate 2000000 restart-ms 1000 berr-reporting on 
```

Setting up these interfaces on boot on Raspbian would look as follows
```bash
cat /etc/network/interfaces.d/can
```

```bash
auto can0
iface can0 inet manual
  pre-up /sbin/ip link set can0 type can bitrate 500000 dbitrate 2000000 restart-ms 1000 berr-reporting on fd on
  up     /sbin/ip link set can0 txqueuelen 65536 up
  down   /sbin/ip link set can0 down

auto can1
iface can1 inet manual
  pre-up /sbin/ip link set can1 type can bitrate 500000 dbitrate 2000000 restart-ms 1000 berr-reporting on fd on
  up     /sbin/ip link set can1 txqueuelen 65536 up
  down   /sbin/ip link set can1 down
```

## Advanced topics


### Start in distributed mode

If you want to run RemotiveBroker in the special distributed mode, its node name
needs to be set. Run it like this:

```bash
NODE_NAME=$(scripts/resolve-ip.sh eth0) docker-compose up -d
```

`$(scripts/resolve-ip.sh eth0)` assumes that the interface for your main
ethernet connection is called `eth0`. If that's not the case, you need to
change `eth0` to the correct name. (Hint: you can can find your interface name
using `ip addr` or `ifconfig`).

Example configuration and detailed instructions can be found [here](configuration_distributed/README.md).

## Stop

```bash
docker-compose down
```

## Upgrade (optionally in distributed mode)

When you upgrade; remember to upgrade **THIS** repository as well `git pull`,
as examples are continuously updated and improved. You will also find the
latest pre-generated grpc files in this repository.

```bash
git pull
./upgrade.sh
```

Alternatively, just pull the latest container images manually:

```base
docker-compose pull
```

If you are running in distributed mode, the same required node name should be
passed to the script, similar to when you first started the system:

```base
NODE_NAME=$(scripts/resolve-ip.sh eth0) ./upgrade.sh
```

### Upgrade through the web interface

It is possible to trigger an upgrade through the RemotiveBroker web interface.
This require a service to be running. To install and start this service (only
needed once):

```bash
sudo scripts/install-service.sh
```

## Use a specific version (advanced feature)

To pull a specific version you can specify custom tag for `REMOTIVEBROKER_TAG` or
`REMOTIVEWEBAPP_TAG`, as in:

```bash
REMOTIVEBROKER_TAG=v0.0.7-4-g12 docker-compose up -d
```