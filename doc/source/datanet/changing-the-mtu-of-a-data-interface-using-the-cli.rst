
.. hyg1467916541021
.. _changing-the-mtu-of-a-data-interface-using-the-cli:

================================================
Change the MTU of a Data Interface Using the CLI
================================================

You can change the MTU value for a data interface from the OpenStack Horizon
Web interface or the CLI.

.. rubric:: |context|

The MTU must be changed while the worker host is locked.

You can use CLI commands to lock and unlock hosts, and to modify the MTU
on the hosts.

.. code-block:: none

    ~(keystone_admin)]$ system host-lock <nodeName>
    ~(keystone_admin)]$ system host-if-modify <nodeName> <interface name> --imtu <mtu_size>
    ~(keystone_admin)]$ system host-unlock <nodeName>

where:

**<nodename>**
    is the name of the host

**<interface name>**
    is the name of the interface

**<mtu\_size>**
    is the new MTU value

For example:

.. code-block:: none

    ~(keystone_admin)]$ system host-if-modify worker-0 enp0s8 --imtu 1496

.. note::
    You cannot set the MTU on an openstack-compute-labeled worker node
    interface to a value smaller than the largest MTU used on its data
    networks.