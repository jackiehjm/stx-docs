
.. jow1423173019489
.. _network-planning-shared-vlan-or-multi-netted-ethernet-interfaces:

===================================================
Shared (VLAN or Multi-Netted) Ethernet Interfaces
===================================================

The management, cluster host, |OAM|, and physical networks can share Ethernet
or aggregated Ethernet interfaces using |VLAN| tagging or IP Multi-Netting.

The |OAM|, internal management, and cluster host networks can use |VLAN|
tagging or IP Multi-Tagging, allowing them to share an Ethernet or aggregated
Ethernet interface with other networks. The one restriction is that if the
internal management network is implemented as a |VLAN|-tagged network, then it
must be on the physical interface used for |PXE| booting.

The following arrangements are possible:

.. _network-planning-shared-vlan-or-multi-netted-ethernet-interfaces-ul-y5k-zg2-zq:

-   One interface for the internal management network and internal cluster host
    network using multi-netting, another interface for |OAM| (on which
    container workloads are exposed externally) and one or more additional
    interfaces data networks. This is the default configuration.

-   One interface for the internal management network, another interface for
    the |OAM| network, a third interface for the cluster host network, and one
    or more additional interfaces for data networks.

-   One interface for the internal management network, with the |OAM| and
    cluster host networks also implemented on the interface using |VLAN|
    tagging, and additional interfaces for data networks .

For some typical interface scenarios, see :ref:`Managed Kubernetes Cluster
Hardware Requirements <hardware-requirements>`.

For more information about configuring |VLAN| interfaces, see |node-doc|:
:ref:`Configure VLAN Interfaces Using the CLI
<configuring-vlan-interfaces-using-the-cli>`.
