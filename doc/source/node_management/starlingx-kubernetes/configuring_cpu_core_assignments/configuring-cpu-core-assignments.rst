
.. epz1565872908287
.. _configuring-cpu-core-assignments:

==============================
Configure CPU Core Assignments
==============================

You can improve the performance of specific functions by assigning them to
CPU cores from the Horizon Web interface.

.. rubric:: |proc|

#.  Lock the host to make changes.

    #.  Select **Admin** \> **System** \> **Inventory**.

    #.  Select the **Hosts** tab.

    #.  In the **Actions** column, open the drop-down list for the host,
        and then select **Lock Host**.

    #.  Wait for the host to be reported as **Locked**.

#.  Access the Host Detail page for a host.

    Select **Admin** \> **Platform** \> **Host Inventory**, and then on the
    Hosts tab, click the host name.

#.  Switch to the Processor tab.

#.  Click **Edit CPU Assignments**.

    The Edit CPU Assignments dialog appears.

    .. figure:: ../figures/tku1572941730454.png
        :scale: 100%

#.  Make CPU allocation changes.

    The options available for worker nodes differ from those for controller
    and storage nodes.

    .. table::
        :widths: auto

        +-------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | **On a worker node or AIO node**    | You can assign cores to specific functions, as illustrated above. Unassigned cores are available for allocation to hosted applications; for example containers or, in the case of the |prod-os| OpenStack application, virtual machines.  |
        +-------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | **On a controller or storage node** | Only the Platform function is shown, and all available cores are automatically assigned as platform cores.                                                                                                                                |
        +-------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

    The functions that can be assigned to cores are:

    **Platform**
        You can reserve one or more cores per |NUMA| node for platform use.
        One core on each host is required to run the operating system and
        associated services. For a combined controller and worker node in a
        |prod| Simplex or Duplex configuration, two cores are required.

        The ability to assign platform cores to specific |NUMA| nodes offers
        increased flexibility for high-performance configurations. For
        example, you can dedicate certain |NUMA| nodes for platform
        use such that other |NUMA| nodes that service IRQ requests are left
        available for the containers \(hosted applications\) that require
        high-performance IRQ servicing.

    **Isolated**
        You can isolate a core from the host process scheduler by specifying
        the Isolated function. This allows you to customize Kubernetes CPU
        management to allow high-performance, low-latency applications to run
        with optimal efficiency.

.. xbooklink  For more information on core isolation, see |admintasks-doc|: `Kubernetes CPU Manager Static Policy <isolating-cpu-cores-to-enhance-application-performance>`.

        To use this feature, you must also assign the node label
        kube-cpu-mgr-policy the value **static**. For information about
        labels, see :ref:`Configure Node Labels Using Horizon <configuring-node-labels-using-horizon>`.

        It is not permitted to have Isolated and vSwitch cores on the same
        node.

    **vSwitch**
        .. note::
            vSwitch is only applicable when running the |prod-os| OpenStack
            application.

        Virtual Switch cores can be configured for each processor
        independently. This means that the single logical vSwitch running
        on a worker node can make use of cores in multiple processors, or
        |NUMA| nodes. Optimal data path
        performance is achieved when all vSwitch cores, the physical ports,
        and the containers that use them are running on the same processor

        You can affine containers to |NUMA|
        nodes with vSwitch cores. Alternatively, having vSwitch cores on all
        processors ensures that all containers, regardless of the core they
        run on, are efficiently serviced. The example allocates two cores
        from processor 1 to the vSwitch threads.

        It is not permitted to have Isolated and vSwitch cores on the same
        node.

        .. note::
            When allocating vSwitch cores, consider optimizing the processing
            of packets to and from physical ports used for data interfaces.

        .. note::
            If the vSwitch type is set to **None**, newly installed worker
            hosts will start with 0 vSwitch CPUs. vSwitch CPUs can only be set
            to 0 through the system :command:`host-cpu-modify` command or
            Horizon.

    **Shared**
        Not currently supported.

    To see how many cores a processor contains, hover over the
    **Information** icon.

    .. figure:: ../figures/jow1436300231676.png
        :scale: 100%
