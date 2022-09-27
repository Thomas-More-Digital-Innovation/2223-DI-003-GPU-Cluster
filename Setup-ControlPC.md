# Setup of control computer
This page is dedicated to the installation of the setup computer.

1. Install Ubuntu 22.04 LTS using the defaults.  
1. Install OpenSSH Server (optional)  
   This can be used to access the computer from a remote computer through SSH.
1. Install minicom (optional)  
   This can be used to access the serial port of the computer to manage the Cisco switch.
1. Add the K8S network VLAN to the computer using nmcli.  
   The network we are using for this is _172.16.0.0/24_. This computers address will be _172.16.0.1_.
   You can do this using `nmcli connection add type vlan con-name VLAN20 dev enp0s31f6 id 20 ip4 172.16.0.1/24`.
1. Enable the kernel to route packages between networks.  
   You can do this by setting `net.ipv4.ip_forward` to `1` and running `sudo sysctl -p` afterwards.
1. Setup the computer to act as a NAT router. This is to allow our nodes to access the internet.  
   You can do this by adding the following `iptables` rules.
   - `sudo iptables -t nat -A POSTROUTING -o enp0s31f6 -j MASQUERADE`
   - `sudo iptables -A FORWARD -i enp0s31f6 -o VLAN20 -m state --state RELATED,ESTABLISHED -j ACCEPT`
   - `sudo iptables -A FORWARD -i VLAN20 -o enp0s31f6 -j ACCEPT`
1. Install the DHCP and DNS server, _dnsmasq_ in this case.  
   You can do this using `sudo apt install dnsmasq`.
   An example configuration is provided [here](configuration/control/dnsmasq.conf)
1. Install matchbox to TFTP-boot Fedora CoreOS / Flatcar Linux.
   You can do this using these instruction:  
   -  `git clone https://github.com/poseidon/matchbox.git`
   - Follow the instructions at https://matchbox.psdn.io/network-setup/
   - Follow the instructions at https://matchbox.psdn.io/deployment/
1. Install typhoon to provision the bare-metal cluster.  
