
.. tss1516219381154
.. _network-requirements-ip-support:

==========
IP Support
==========

|prod| supports IPv4 and IPv6 versions for various networks.

All platform networks must be a single address family, either IPv4 or IPv6, with the
exception of the |PXE| boot network which must always use IPv4. The following
table lists IPv4 and IPv6 support for different networks:

.. _network-requirements-ip-support-table-xqy-3cj-4cb:

.. list-table:: Table 1. IPv4 and IPv6 Support
   :header-rows: 1

   * - Networks
     - IPv4 Support
     - IPv6 Support
     - Comment
   * - |PXE| boot
     - Y
     - N
     - If present, the |PXE| boot network is used for |PXE| booting of new
       hosts (instead of using the internal management network), and must be
       untagged. It is limited to IPv4, because the |prod| installer does not
       support IPv6 |UEFI| booting.
   * - Internal Management
     - Y
     - Y
     - -
   * - OAM
     - Y
     - Y
     - -
   * - Cluster Host
     - Y
     - Y
     - The Cluster Host network supports IPv4 or IPv6 addressing.
   * - Data Network and |SRIOV| Interface
     - Y
     - Y
     - There is no restriction for the Data Network and |SRIOV| Interfaces to
       have the same address family as the platform. They operate independently
       from the platform and are capable of supporting both IPv4 and IPv6
       addressing, offering flexible options for network connectivity. However,
       IPv4 or IPv6 requires dedicated |IPAM| pools or static address
       configuration to use the corresponding address families with the |SRIOV|
       Interfaces. For more information about |IPAM| pools configuration, see
       https://docs.tigera.io/calico/latest/reference/resources/ippool. 
       
    

       
