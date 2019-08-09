#!/usr/bin/env bash

cat << EOF > /etc/consul.d/client.json
{
 "bind_addr": "${ip}",
 "datacenter": "dc-east",
 "data_dir": "/opt/consul",
 "log_level": "INFO",
 "enable_syslog": true,
 "enable_debug": true,
 "node_name": "dc-east-${hostname}",
 "server": false,
 "rejoin_after_leave": true,
 "retry_join": [
    "172.20.20.111"
    ]
}
EOF

# "retry_join": [
#    "172.20.20.11","172.20.20.12","172.20.20.13"
#    ]

# Consul should own its configuration files
chown --recursive consul:consul /etc/consul.d

# Starting consul
sudo systemctl start consul