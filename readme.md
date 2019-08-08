### Simple Vagrant example of using Consul cluster in multi data center environment.

### The configuration is extensible, the current setup provided looks like this: 

![diagram](https://www.lucidchart.com/publicSegments/view/35a56c10-9376-470f-8e80-d90cb1b37132/image.png)

### How to use it :

- In a directory of your choice, clone the github repository :
    ```
    git clone https://github.com/martinhristov90/consul_multi_datacenter_geo.git
    ```

- Change into the directory :
    ```
    cd consul_multi_datacenter_geo
    ```
- Run `vagrant up` in both `dc_east` and `dc_west` folders.

- You should now have a Consul multi-datacenter environment, with one server and client in each DC.

- All clients named client-node-1 in both DCs `dc-east` and in `dc-west` provide a simple service called `web`. (Review simple_service.sh for mode details)

- `web` service is the same on both clients, but with different tags, the one in `dc-east` is tagged with `v1.2.3`, the one in `dc-west` with `v1.2.4`.

- Lets create a `prepared query` that is only going to look for `web` service with tag `v1.2.4`. Execute `curl http://127.0.0.1:8500/v1/query --request POST --data @payload.json` (in `dc-east`). The output should look like this :
```
dc_east $  curl http://127.0.0.1:8500/v1/query --request POST  --data @payload.json
{"ID":"66fe5cc5-9d3a-725e-6743-378248264e20"} # The ID of the query.
```
This query is going to look for `web` service with tag `v1.2.4` first in `dc-east` and then in `dc-west`.

- Now, lets make sure the query works by executing :
```
dc_east $  dig @127.0.0.1 -p 8600 web.query.consul +short
172.20.20.221 # IP of web running in dc-west
```
It returns the IP address of the `web` service of `client-node-1` in `dc-west`.Remember only the `web` service in `dc-west` is running `v1.2.4`. Now lets change the tag of the `web` service that is running in `dc-east` to `v.1.2.4`, and execute the DNS query again, in `dc-east` folder execute :
```
vagrant ssh client-node-1
sudo vi /etc/consul.d/service_web.json
CHANGE TAG TO v1.2.4
consul reload
```
Lets rerun the DNS query, it should return the IP of the `web` service running in `dc-east` :
```
dc_east $  dig @127.0.0.1 -p 8600 web6.query.consul +short
172.20.20.121 # IP of web running in dc-east
```

- It works.

### Nota Bene:
- If you decide to extend the configuration to 3 Consul servers in each DC and more client, you need good hardware before doing it.
- Consul servers number 2 and 3 both DCs are not being used in this example, they might be used for extending the setup.
- Port `8500` from `dc-east-server-node-1` is exposed to port `8500` of the host machine.
- Port `8600` from `dc-west-server-node-1` is exposed to port `8600` of the host machine.

