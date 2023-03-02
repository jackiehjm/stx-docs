===================================
Configure VirtualBox Network Access
===================================

This guide describes two alternatives for providing external network access
to the controller |VMs| for VirtualBox:

.. contents::
   :local:
   :depth: 1

----------------------
Install VM as a router
----------------------


A router can be used to act as a gateway to allow your other VirtualBox VMs
(for example, controllers) access to the external internet. The router needs to
be able to forward traffic from the OAM network to the internet.

In VirtualBox, create a new Linux VM to act as your router. This example uses
Ubuntu. For ease of use, we recommend downloading Ubuntu 18.04 Desktop
version or higher.

**Installation tip**

Before you install the Ubuntu 18.04 Desktop version in a Virtual Box 5.2,
configure the VM using Edit Settings as follows:

#.  Go to Display and move the "Video memory" slider all the way to the right.
    Then tick the "Acceleration" checkbox "Enable 3D Acceleration".
#.  Go to General/Advanced and set "Shared Clipboard" and "Drag'n Drop" to
    Bidirectional.
#.  Go to User Interface/Devices and select "Devices/Insert Guest Additions CD
    image" from the drop down. Restart your VM.

The network configuration for this VM must include:

*   NAT interface to allow installation and access to the external internet.
*   Host-only Adapter connected to the same network as the OAM interfaces on
    your controllers.

Once the router VM has been installed, enable forwarding. In Ubuntu, do the
following steps:

::

    # Edit sysctl.conf and uncomment the following line:
    # net.ipv4.ip_forward=1
    sudo vim /etc/sysctl.conf
    # Activate the change
    sudo sysctl -p

Then add the gateway IP address to the interface connected to the OAM host only
network:

::

    # Assuming that enp0s8 is connected to the OAM host only network:
    cat > /etc/netplan/99_config.yaml << EOF
    network:
      version: 2
      renderer: networkd
      ethernets:
        enp0s8:
          addresses:
            - 10.10.10.1/24
    EOF
    sudo netplan apply

    # If netplan is not installed on your router you can use these commands instead of the above.
    ip addr add 10.10.10.1/24 dev enp0s8

Finally, set up iptables to forward packets from the host only network to the
NAT network:

::

    # This assumes the NAT is on enp0s3 and the host only network is on enp0s8
    sudo iptables -t nat -A POSTROUTING --out-interface enp0s3 -j MASQUERADE
    sudo iptables -A FORWARD --in-interface enp0s8 -j ACCEPT
    sudo apt-get install iptables-persistent


-----------------------------
Add NAT Network in VirtualBox
-----------------------------

#.  Select File -> Preferences menu.
#.  Choose Network, ``Nat Networks`` tab should be selected.
#.  Click on plus icon to add a network, which will add a network named
    NatNetwork.
#.  Edit the NatNetwork (gear or screwdriver icon).

    *   Network CIDR: 10.10.10.0/24 (to match OAM network specified in
        ansible bootstrap overrides file)
    *   Disable ``Supports DHCP``
    *   Enable ``Supports IPv6``
    *   Select ``Port Forwarding`` and add any rules you desire. Here are some
        examples where 10.10.10.2 is the StarlingX OAM Floating IP address and
        10.10.10.3/.4 are the IP addresses of the two controller units:


+-------------------------+-----------+---------+-----------+------------+-------------+
| Name                    |  Protocol | Host IP | Host Port | Guest IP   |  Guest Port |
+=========================+===========+=========+===========+============+=============+
| controller-0-ssh        | TCP       |         | 3022      | 10.10.10.3 |  22         |
+-------------------------+-----------+---------+-----------+------------+-------------+
| controller-1-ssh        | TCP       |         | 3122      | 10.10.10.4 |  22         |
+-------------------------+-----------+---------+-----------+------------+-------------+
| controller-ssh          | TCP       |         | 22        | 10.10.10.2 |  22         |
+-------------------------+-----------+---------+-----------+------------+-------------+
| platform-horizon-http   | TCP       |         | 8080      | 10.10.10.2 |  8080       |
+-------------------------+-----------+---------+-----------+------------+-------------+
| platform-horizon-https  | TCP       |         | 8443      | 10.10.10.2 |  8443       |
+-------------------------+-----------+---------+-----------+------------+-------------+
| openstack-horizon-http  | TCP       |         | 80        | 10.10.10.2 |  80         |
+-------------------------+-----------+---------+-----------+------------+-------------+
| openstack-horizon-https | TCP       |         | 443       | 10.10.10.2 |  443        |
+-------------------------+-----------+---------+-----------+------------+-------------+

~~~~~~~~~~~~~
Access the VM
~~~~~~~~~~~~~

Once your VM is running, use your PC's host address and the forwarded port to
access the VM.

Instead of these commands:

::

    # ssh to controller-0
    ssh wrsroot@10.10.10.3
    # scp file to controller-0
    scp <filename> wrsroot@10.10.10.3:~

Enter these commands instead:

::

    # ssh to controller-0
    ssh -p 3022 wrsroot@<PC hostname or IP>
    # scp file to controller-0
    scp -P 3022 <filename> wrsroot@<PC hostname or IP>:~


To access your VM console from Horizon, you can update the VNC proxy address
using service parameters. The worker nodes will require a reboot following
this change, therefore it is best to perform this operation before unlocking
the worker nodes.


::

    # update vnc proxy setting to use NatNetwork host name
    system service-parameter-add nova vnc vncproxy_host=<hostname or IP> --personality controller --resource nova::compute::vncproxy_host # aio
    system service-parameter-add nova vnc vncproxy_host=<hostname or IP> --personality compute --resource nova::compute::vncproxy_host # standard
    system service-parameter-apply nova


