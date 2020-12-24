
.. rjo1552677308677
.. _allocating-host-memory-using-horizon:

==================================
Allocate Host Memory Using Horizon
==================================

You can edit the platform, vSwitch, and Application page memory allocations
for a |NUMA| node from the Horizon Web
interface using the **Memory** tab on the Host Inventory pane.

Due to limitations in Kubernetes, only a single huge page size can be used
per host.

A node may only allocate huge pages for a single size, either 2MiB or 1GiB.
Since the vSwitch uses 1GiB huge page by default, the application will
typically also use 1GiB huge pages. However, the vSwitch page size can be
changed to 2MiB, in which case the application would also use 2MiB huge
pages.

You must also provision one 1GiB huge page per |NUMA| node prior to unlocking a
worker or an |AIO| controller.

.. rubric:: |prereq|

Before requesting huge pages on a host, ensure that the host has enough
available memory. For details,
see :ref:`About Host Memory Provisioning <about-host-memory-provisioning>`.
If a huge page request cannot be allocated from the available memory, an
informative message is displayed.

.. rubric:: |proc|

#.  On the **Inventory** pane, lock the host you want to edit.

#.  Click **Host Name** to open the settings for the host.

#.  On the **Memory** tab, click **Update Memory**.

    .. figure:: ../figures/esy1567176125909.png
        :scale: 100%

#.  Use the Update Memory Allocation dialog box to set the memory allocations
    for each |NUMA| node.

    For each available |NUMA| node, five
    fields are available, as illustrated in the following example screen for
    two |NUMA| nodes.

    .. figure:: ../figures/yfv1567176747837.png
        :scale: 100%

    **Platform Memory for Node n**
        The amount of memory to reserve for platform use on the
        |NUMA| Node, in MiB. To see the
        minimum requirement, hover over the information icon next to the
        field.

        .. figure:: ../figures/jow1436294915672.png
            :scale: 100%

    **\# of Application 2M Hugepages Node n**
        The number of 2 MiB huge pages to reserve for application use on the
        |NUMA| Node. If no 2 MiB pages are
        required, type 0.

    **\# of Application 1G Hugepages Node n**
        The number of 1 GiB huge pages to reserve for application use on the
        |NUMA| Node. If no 1 GiB pages are
        required, type 0.

    **\# of vSwitch 1G Hugepages Node n**
        The number of 1 GiB huge pages to reserve for vS2witch use on the
        |NUMA| Node. If no 1 GiB pages are
        required, type 0.

    **vSwitch Hugepage Size Node n**
        Select the hugepage size to use for the node.

    To see how many huge pages of a given size you can successfully request
    on a node \(assuming that pages of another size are not also requested\),
    hover over the information icon next to the field.

    .. figure:: ../figures/jow1432129731308.png
        :scale: 100%

    Any unused memory is automatically allocated as 4 KiB pages of regular
    memory for Applications.

#.  Click **Save**.

#.  Unlock the host and wait for it to be reported as **Available**.

.. only:: partner

    .. include:: ../../../_includes/avs-note.rest
