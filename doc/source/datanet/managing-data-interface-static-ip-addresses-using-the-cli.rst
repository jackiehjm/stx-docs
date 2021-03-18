
.. jow1425584170078
.. _managing-data-interface-static-ip-addresses-using-the-cli:

=======================================================
Manage Data Interface Static IP Addresses Using the CLI
=======================================================

If you prefer, you can create and manage static addresses for data interfaces
using the |CLI|.

.. rubric:: |context|

For more information about using static addresses for data interfaces, see
:ref:`Adding a Static IP Address to a Data Interface
<adding-a-static-ip-address-to-a-data-interface>`.

.. rubric:: |prereq|

To make interface changes, you must lock the compute node first.

.. rubric:: |proc|

.. _managing-data-interface-static-ip-addresses-using-the-cli-steps-zkx-d1h-hr:

#.  Lock the compute node.

#.  Set the interface to support an IPv4 or IPv6 address, or both.

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-modify <node> <ifname> --ipv4-mode=<ipv4mode> --ipv6-mode=<ipv6mode>

    where

    **node**
        is the name or |UUID| of the compute node

    **ifname**
        is the name of the interface

    **ipv4mode**
        is either **disabled** or **static**

    **ipv6mode**
        is either **disabled** or **static**

#.  Add an IPv4 or IPv6 address to the interface.

    .. code-block:: none

        ~(keystone_admin)]$ system host-addr-add <node> <ifname> <ip_address> <prefix>

    where

    **node**
        is the name or |UUID| of the compute node

    **ifname**
        is the name of the interface

    **ip\_address**
        is an IPv4 or IPv6 address

    **prefix**
        is the netmask length for the address

    To delete an address, use the following commands:

    .. code-block:: none

        ~(keystone_admin)]$ system host-addr-list <hostname/ID>

    This displays the |UUIDs| of existing addresses, as shown in this example
    below.

    .. code-block:: none

        ~(keystone_admin)]$ system host-addr-list compute-0
        +-----------------------+--------+------------------------+--------+
        | uuid                  | ifname | address                | prefix |
        +-----------------------+--------+------------------------+--------+
        | 290629f6-41e5-48d9... | ae0    | 2605:6400:2:fed5:22... | 112    |
        | 5de0e0bf-21fc-4532... | ae0    | 2605:6400:2:fed5:22... | 122    |
        | e78923d7-3ccf-4332... | ae0    | 192.168.61.70          | 27     |
        +-----------------------+--------+------------------------+--------+

    .. code-block:: none

        ~(keystone_admin)]$ system host-addr-delete <uuid>

    where **uuid** is the |UUID| of the address.

#.  Unlock the compute node and wait for it to become available.