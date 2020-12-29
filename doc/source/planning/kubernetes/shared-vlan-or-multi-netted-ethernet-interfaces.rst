
.. rei1552671031876
.. _shared-vlan-or-multi-netted-ethernet-interfaces:

===================================================
Shared \(VLAN or Multi-Netted\) Ethernet Interfaces
===================================================

The management, |OAM|, cluster host, and other networks for container workload
external connectivity, can share Ethernet or aggregated Ethernet interfaces
using |VLAN| tagging or IP Multi-Netting.

The |OAM| internal management cluster host, and other external networks, can
use |VLAN| tagging or IP Multi-Netting, allowing them to share an Ethernet or
aggregated Ethernet interface with other networks. If the internal management
network is implemented as a |VLAN|-tagged network then it must be on the same
physical interface used for |PXE| booting.

The following arrangements are possible:


.. _shared-vlan-or-multi-netted-ethernet-interfaces-ul-y5k-zg2-zq:

-   One interface for the internal management network and internal cluster host
    network using multi-netting, and another interface for |OAM| \(on which
    container workloads are exposed externally\). This is the default
    configuration.

-   One interface for the internal management network and another interface for
    the external |OAM| and external cluster host \(on which container workloads
    are exposed externally\) networks. Both are implemented using |VLAN|
    tagging.

-   One interface for the internal management network, another interface for
    the external |OAM| network, and a third for an external cluster host
    network \(on which container workloads are exposed externally\).

-   One interface for the internal management network and internal cluster host
    network using multi-netting, another interface for |OAM| and a third
    interface for an additional network on which container workloads are
    exposed externally.


For some typical interface scenarios, see |planning-doc|: :ref:`Hardware
Requirements <starlingx-hardware-requirements>`.

Options to share an interface using |VLAN| tagging or Multi-Netting are
presented in the Ansible Bootstrap Playbook. To attach an interface to other
networks after configuration, you can edit the interface.

.. xbooklink For more information about configuring |VLAN| interfaces and Multi-Netted interfaces, see |node-doc|: :ref:`Configure VLAN Interfaces Using Horizon <configuring-vlan-interfaces-using-horizon>`.

