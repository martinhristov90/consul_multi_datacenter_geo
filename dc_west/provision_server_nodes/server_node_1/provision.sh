#!/usr/bin/env bash

cat << EOF > /etc/consul.d/server_node_1_config.json
{
 "bind_addr": "172.20.20.211",
 "datacenter": "dc-west",
 "data_dir": "/opt/consul",
 "log_level": "INFO",
 "enable_syslog": true,
 "enable_debug": true,
 "node_name": "dc-west-consul-server-one",
 "server": true,
 "client_addr": "0.0.0.0",
 "bootstrap_expect": 1,
 "rejoin_after_leave": true,
 "ui": true,
 "retry_join_wan": [
    "172.20.20.111"
    ]
}
EOF

# "retry_join": [
#    "172.20.30.12","172.20.30.13"
#    ],

# Consul should own its configuration files
chown --recursive consul:consul /etc/consul.d

# Starting consul
sudo systemctl start consul



