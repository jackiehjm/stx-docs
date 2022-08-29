=====================
Hardware Requirements
=====================

This section describes the hardware requirements and server preparation for a
**StarlingX R7.0 bare metal Ironic** deployment configuration.

.. contents::
   :local:
   :depth: 1

-----------------------------
Minimum hardware requirements
-----------------------------

* One or more bare metal hosts as Ironic nodes as well as tenant instance node.

* BMC support on bare metal host and controller node connectivity to the BMC IP
  address of bare metal hosts.

For controller nodes:

* Additional NIC port on both controller nodes for connecting to the
  ironic-provisioning-net.

For worker nodes:

* If using a flat data network for the Ironic provisioning network, an additional
  NIC port on one of the worker nodes is required.

* Alternatively, use a VLAN data network for the Ironic provisioning network and
  simply add the new data network to an existing interface on the worker node.

* Additional switch ports / configuration for new ports on controller, worker,
  and Ironic nodes, for connectivity to the Ironic provisioning network.

-----------------------------------
BMC configuration of Ironic node(s)
-----------------------------------

Enable BMC and allocate a static IP, username, and password in the BIOS settings.
For example, set:

IP address
  10.10.10.126

username
  root

password
  test123
