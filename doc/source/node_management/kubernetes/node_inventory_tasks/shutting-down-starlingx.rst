
.. hrf1552674782974
.. _shutting-down-starlingx:

====================
Shut Down the System
====================

Performing a controlled shutdown of an entire |prod| system may become
necessary if, for instance, you need to physically move the underlying
hardware.

For information on restarting the cluster, see :ref:`Start the System
<starting-starlingx>`.

.. rubric:: |prereq|

On a system that contains storage nodes, a local console or a |BMC| console
connected to **storage-0** is required so that you can issue a shutdown
command in the final step of this procedure.

.. rubric:: |proc|

#.  Swact to controller-0.

    From the **Admin** \> **Platform** \> **Host Inventory** page, on the
    Hosts tab, select **Edit Host** \> **Swact Host** for controller-0.

#.  Lock and shut down each worker node.

    #.  From the **Admin** \> **Platform** \> **Host Inventory** page,
        on the Hosts tab, select **Edit Host** \> **Lock Host**.

    #.  From the terminal of the worker node, issue a :command:`shutdown`
        command.

        .. code-block:: none

            # sudo shutdown -hP now

        Wait until the node is completely shut down before proceeding to
        the next step.

#.  Lock and shut down each storage node except for **storage-0**.

    **Storage-0** is required as part of the Ceph monitor quorum. Do not
    shut it down until the controllers have been shut down.

    .. note::
        This step applies to Ceph-backed systems
        (systems with storage nodes) only.

    #.  From the **Admin** \> **Platform** \> **Host Inventory** page, on the
        Hosts tab, select **Edit Host** \> **Lock Host**.

    #.  From the terminal of **storage-1**, issue a :command:`shutdown`
        command.

        .. code-block:: none

            # sudo shutdown -hP now

    Wait for several minutes to ensure Ceph has detected and reacted to the
    missing storage node. You can use :command:`ceph -s` to verify that the
    OSDs on storage-1 are down.

#.  Lock and shut down **controller-1**.

    #.  From the **Admin** \> **Platform** \> **Host Inventory** page, on the
        Hosts tab, select **Edit Host** \> **Lock Host**.

    #.  From the terminal of **controller-1**, issue a :command:`shutdown`
        command.

        .. code-block:: none

            # sudo shutdown -hP now

    Wait until the node is completely shut down before proceeding to the
    next step.

#.  Shut down **controller-0**.

    You cannot lock this controller node, as it is the last remaining
    controller node.

    .. code-block:: none

        # sudo shutdown -hP now

    Wait until the node is completely shut down before proceeding to the
    next step.

#.  Shut down **storage-0**.

    .. note::
        This step applies to Ceph-backed systems (systems with storage nodes)
        only.

    You must use a local console or a |BMC| console to issue the shutdown
    command.

    .. code-block:: none

        # sudo shutdown -hP now
