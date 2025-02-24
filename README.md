# RemotiveBroker bootstrapped

## Run it yourself

Remotive Labs provides integrations to various platforms ([read more](https://remotivelabs.github.io/)), however in many cases 
you might prefer to host the software in a machine of your choice. If so; you are in the correct location, 
keep reading.

prerequisites:
- `docker` 
- `docker compose`
- `git` 
- `inotify-tools` (optional)

### Step 1/3 start using docker 

Clone this repository and make sure you have `docker` and `docker compose`
installed, then run:

```bash
docker compose up -d
```

This command only needs to be run once. It is persistent over system reboot --
the containers will be restarted after a reboot, over and over again.

Point your web browser at the machine running RemotiveBroker, an address like
`http://192.0.2.42:8080/`. 


**Please note**, *the following license applies to the usage of Remotive Labs products, which is also shown when you run `docker compose up` in attached mode.*
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


### Step 2/3 (optional, quality of life improvement) Upgrade through the web interface

In order to allow upgrades triggered by the user interface you need to install a 
custom service. To install and start this service (only needed once):

```bash
sudo scripts/install-service.sh
```

> This script assumes that you are running on a host where `systemd` is present 

### Step 3/3 Get evaluation license

Navigate to you local broker [here](http://127.0.0.1:8080) and select the `License` tab and follow the instructions to aquire your license. 

## Custom can interfaces

RemotiveBroker support all can interfaces which supports `socket-can`. Many USB 
can connectors are supported by default by the linux kernel. Typically, it will appear
when you do `ip a` then you simply need to do:
```bash
#can/canfd
ip link set can0 type can bitrate 500000 dbitrate 2000000 restart-ms 1000 berr-reporting on fd on
## less capable device 
#can
ip link set can0 type can bitrate 500000 dbitrate 2000000 restart-ms 1000 berr-reporting on

## if above doesn't work try
ip link set can0 up type can bitrate 500000 restart-ms 1000
```
> Remember to run as sudo if you run from shell


Setting up these interfaces on boot on Raspbian would look as follows
```bash
cat /etc/network/interfaces.d/can
```

```bash
auto can0
iface can0 inet manual
  pre-up /sbin/ip link set can0 type can bitrate 500000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
  up     /sbin/ip link set can0 txqueuelen 65536 up
  down   /sbin/ip link set can0 down
auto can1
iface can1 inet manual
  pre-up /sbin/ip link set can1 type can bitrate 500000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
  up     /sbin/ip link set can1 txqueuelen 65536 up
  down   /sbin/ip link set can1 down

## some devices do not support berr-reporting on
## if above doesn't work try
iface can2 inet manual
  pre-up /sbin/ip link set can2 type can bitrate 500000 restart-ms 1000
  up     /sbin/ip link set can2 txqueuelen 65536 up
  down   /sbin/ip link set can2 down
```

## LIN, Flexray and Ethernet

These protocols are carried over ethernet, however dependent on you HW choice let us help. Reach out on [hello@remotivelabs.com](mailto:hello@remotivelabs.com?subject=Help%20with%20setting%20up%20interfaces). 
Some guidance can be located below.

### Technica

It's recommended to install a bridge module on the same host machine. The scrips provided [here](scripts/install-teknika.sh) will install 2 services, allowing two Technica devices (thus enabling 2 flexray interfaces), one on port 51112 and the other on port 51113. 

!> Make sure that your Technica devices is configured to use `PLP` headers and also make sure to note specified `Destination MAC` (available by clicking `SPY`) typically `01:00:5e:00:00:00`. 

Connect your Technica device to the secondary usb ethernet interface `eth1` which is mentioned above. As multicast address provide `Destination MAC`.
```json
{
  "chains": [
      {
         "type": "flexray",
         "device_name": "flexray0",
         "namespace": "MyFlexrayNamespace",
         "config": {
            "target_host": "127.0.0.1",
            "target_port": 51112,
            "hardware": "Technica_CM_CAN_COMBO",
            "target_config": {
               "interface": "eth1",
               "multicast": "01:00:5e:00:00:00"
            }
         },
         "database": "fibex_files/flexray.xml"
      }
   ]
}
```

### Host Mobility MX-4 T30 FR as a flexray forwarding device

The binary located [here](scripts/flexray/flexray2ip.new) need to be installed on the MX-4 T30 FR device. Go [here](scripts/flexray/README.txt) for more information.
```json
{
  "chains": [
      {
         "type": "flexray",
         "device_name": "flexray0",
         "namespace": "MyFlexrayNamespace",
         "config": {
            "target_host": "127.0.0.1",
            "target_port": 51111
         },
         "database": "fibex_files/flexray.xml"
      }
   ]
}
```

## Advanced topics




### Start in distributed mode

This mode enables you to daisy chain machines running RemotiveBroker allowing you to increase number of physical interfaces.
read more [here](configuration_distributed/README.md)

### Time synchronization using PTP

Our prebuild image contains binaries for ptp /home/pi/src/linuxptp typically there is a PTP Grandmaster, to connect go ahead and do:
```bash
sudo ./ptp4l -m -i eth0 -S --step_threshold=1 -f configs/automotive-slave.cfg
```
> Make sure to specify correct interface in the example above `eth0` is used.

### Stop

```bash
docker compose down
```

### Upgrade

When you upgrade; remember to upgrade **THIS** repository as well `git pull`,
as examples are continuously updated and improved. You will also find the
latest pre-generated grpc files in this repository.

```bash
git pull
./upgrade.sh
```

Alternatively, just pull the latest container images manually:

```base
docker compose pull
```

### Use a specific version

To pull a specific version you can specify custom tag for `REMOTIVEBROKER_TAG` or
`REMOTIVEWEBAPP_TAG`, as in:

```bash
REMOTIVEBROKER_TAG=v1.2.3 docker compose up -d
```
> If you have done `Step 2/2` above, you can conveniently pick version from the `About` in the user interface.

### Troubleshoot

To start from a clean configuration you could do:
```bash
rm remotivelabs-bootstrap/configuration/boot
```

You can always reach out to us on [hello@remotivelabs.com](mailto:hello@remotivelabs.com?subject=Hello)
