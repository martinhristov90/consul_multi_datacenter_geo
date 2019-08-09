# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify a custom Vagrant box for the demo
DEMO_BOX_NAME = ENV['DEMO_BOX_NAME'] || "martinhristov90/consul"

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"
# NETWORK SCHEME BELOW :
# dc-east
# IP address scheme server nodes - name: server_node_[1] = IP: 172.20.20.11X
# IP address scheme client nodes - name: client_node_[1] = IP: 172.20.20.12X
# dc-west
# IP address scheme server nodes - name: server_node_[1] = IP: 172.20.20.21X
# IP address scheme client nodes - name: client_node_[1] = IP: 172.20.20.22X

# Remember to set the retry_join IPs in both client and server configs.

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = DEMO_BOX_NAME
  config.vm.box_download_insecure = true
    # Two DC regions
    data_centers = ["dc-east", "dc-west"]

    data_centers.each do |dc_region|

        # How many server to be created in each DC? Up to 3 for now
        server_count = 1

        (1..server_count).each do |s|
        
            config.vm.define "server-node-#{dc_region}-#{s}" do |server_node|
                # IP range depends on the dc 
                ip = "172.20.20.#{110 + s}" if dc_region == "dc-east"
                ip = "172.20.20.#{210 + s}" if dc_region == "dc-west"

                hostname = "server-node-#{dc_region}-#{s}"

                # Following ports will be exposed to the host machine.
                port_host_UI = 8500 + s - 1 if dc_region == "dc-east"
                port_host_UI = 8700 + s - 1 if dc_region == "dc-west"

                # Following ports will be exposed to the host machine.
                port_host_DNS = 8600 + s - 1 if dc_region == "dc-east"
                port_host_DNS = 8800 + s - 1 if dc_region == "dc-west"

                #Printing some useful addressing info
                #puts "SERVER: IP : #{ip}, hostname : #{hostname} port_host_UI : #{port_host_UI}, port_host_DNS : #{port_host_DNS}"

                # Setting hostname in VirtualBox (not to be ugly)
                virtualbox_name = "server-node-dc-east-#{s}" if dc_region == "dc-east"
                virtualbox_name = "server-node-dc-west-#{s}" if dc_region == "dc-west"

                server_node.vm.provider :virtualbox do |vb|
                    vb.name = virtualbox_name
                end

                server_node.vm.hostname = hostname
                server_node.vm.network "private_network", ip: ip
                server_node.vm.network "forwarded_port", guest: 8500, host: port_host_UI # This consul UI port
                server_node.vm.network "forwarded_port", guest: 8600, host: port_host_DNS # This consul DNS port
                # Provision section 
                server_node.vm.provision :shell, path: "#{dc_region}/provision_server_nodes/server_node_#{s}/provision.sh", privileged: true
             end
        end

        # How many clients to be created in each DC. Up to 99 clients, more would cause IP overlap.
        client_count = 1

        (1..client_count).each do |i|

            config.vm.define "client-node-#{dc_region}-#{i}" do |client|
                
                # IP range of the clients depends on the dc 
                ip = "172.20.20.#{120 + i}" if dc_region == "dc-east"
                ip = "172.20.20.#{220 + i}" if dc_region == "dc-west"

                # Setting hostname pattern
                hostname = "client-node-#{dc_region}-#{i}"

                client.vm.hostname = hostname
                client.vm.network "private_network", ip: ip

                # Print some useful information
                #puts "CLIENT: IP : #{ip}, hostname : #{hostname}"

                # Setting hostname in VirtualBox (not to be ugly)
                virtualbox_name = "client-node-dc-east-#{i}" if dc_region == "dc-east"
                virtualbox_name = "client-node-dc-west-#{i}" if dc_region == "dc-west"

                client.vm.provider :virtualbox do |vb|
                    vb.name = virtualbox_name
                end

                # Provision section 
                client.vm.provision :shell, path: "#{dc_region}/provision_client_nodes/provision.sh", privileged: true,  env: {
                  "client_num" => i,
                  "ip" => ip,
                  "hostname" => hostname
                }
                client.vm.provision :shell, path: "#{dc_region}/provision_client_nodes/simple_service.sh", privileged: true

            end
        end
    end
end
