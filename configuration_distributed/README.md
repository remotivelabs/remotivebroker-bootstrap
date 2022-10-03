# Get going with distributed setup

Distributed setup allows chaining devices enabling muliple physical ports. Typically a scenario would be where the host has not enough CAN ports. 

The connected devices can be of different kind. Linux machines can coexist with Raspberry pie:s.

## Setup

1. Make sure all nodes (machines) have license installed.
2. For all nodes - go to the `remotivelabs-bootstrap` folder and do:
```bash
docker-compose down
NODE_NAME=xxx.xxx.xxx.xxx docker-compose up -d
```
> Make sure to replace `xxx.xxx.xxx.xxx` with the proper ip of the machine, alternatively you can parametrise by doing: 
>```
>NODE_NAME=$(scripts/resolve-ip.sh eth0) docker-compose up -d
>```

3. Upload a valid configuration (or modify the configuration in this folder) to all the relevant nodes. All nodes should use the same confiuration file.
4. Using the web interface you should now se all namespaces listed on all machines.
5. Done!

## Valid interfaces.json
All node names must be prefixed with `node`. `slaveX.com` and `master.com` needs to be replaced with the proper ips's which are the same as were used when doing `docker-compose up` above.
```json
{
  "master_node": "node@master.com",
  "nodes": [
    {
      "node_name": "node@slave1.com",
      "default_namespace": "VirtualInterface",
      "chains": [
        {
          ...
        }
      ]
    },
    {
      "node_name": "node@master.com",
      "default_namespace": "UDPCanInterface",
      "chains": [
        {
          ...
        }
      ]
    }
  ]
}

```

## Upgrade while in distributed mode

If you are running in distributed mode, the same required node name should be
passed to the script, similar to when you first started the system:

```base
NODE_NAME=$(scripts/resolve-ip.sh eth0) ./upgrade.sh
```


## Troubleshoot

To start from a clean configuration you could do:
```bash
rm remotivelabs-bootstrap/configuration/boot
```
