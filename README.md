# RemotiveBroker bootstraped
## Run it yourself

Clone this repository and make sure you have `docker` and `docker-compose`
installed, then run:

```bash
docker-compose up -d
```

This command only needs to be run once. It is persistent over system reboot --
the containers will be restarted after a reboot, over and over again.

Point your web browser at the machine running RemotiveBroker, an address like
`http://192.0.2.42:8080/`. If you are connected to a hosted WLAN Access Point
like `beamylabs`, the address should be `http://192.168.4.1:8080/`.

NOTE: if you change your interface settings you must restart by do doing
[STOP](#stop) and the start it again like above.

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