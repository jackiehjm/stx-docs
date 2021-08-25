
.. bvh1551909669780
.. _hosts-tab:

=========
Hosts Tab
=========

The **Hosts** tab on the Host Inventory page provides an overview of the
current state of all hosts in the |prod|. From this tab you can obtain
detailed information about the hosts, and execute maintenance operations.

A sample **Hosts** tab is illustrated below:

.. figure:: /node_management/kubernetes/figures/jpx1567098739405.png
    :scale: 100%

**Host Name**
    The name assigned to the host. This is an active link pointing to the
    detailed inventory page for the host. For more information,
    see :ref:`Host Details Page <host-details-page>`.

**Personality**
    The personality of the host; one of controller, worker, or storage.

**Replication Group**
    For a storage host, the group to which the host belongs. Data is
    replicated on each host in the group.

..  For more information, see  |stor-doc|: `Replication Groups <replication-groups>`.

**Admin State**
    The administrative state of the host:

    **Locked**
        The host is administratively prohibited from performing services.
        This is the initial state for hosts auto-discovered in the cluster.

        A controller node in this state is not functioning in HA mode, and it
        is not running any active controller services.

        Worker and storage nodes in this state do not provide any service. In
        particular, a locked worker node is not running any containers, and
        no new ones will be scheduled to run on it.

    **Unlocked**
        The host is administratively in service.

        A controller node in this state, and not in the failed state, is
        active in its HA role, and is running the assigned controller
        services.

        A worker node in this state, and not in the failed state, is eligible
        for regular scheduling and maintenance operations on containers
        \(hosted applications\).

        -   If the node's vSwitch type is set to **none**, the number of
            vSwitch CPUs must be 0 before
            unlocking the host.

        -   If the node's vSwitch type is set to **ovs-dpdk**, the number of
            vSwitch CPUs must be at lease
            1 before unlocking the host.

        You can set the number of vSwitch CPU using the
        :command:`host-cpu-modify` CPU command or the Horizon Web interface.

        A storage node in this state, and not in the failed state, provides
        storage services.

**Operational State**
    The operational state of the host:

    **Disabled**
        Indicates that the host is not providing the expected services. This
        can be because it is in the process of being unlocked, a failure has
        occurred, or it is being automatically recovered from a failure.

    **Enabled**
        Indicates that the host is providing the expected services, even if
        its operational environment is compromised. In the latter case, the
        host is reported to be in the Degraded availability state, in which
        case, state maintenance is constantly trying to recover the host to
        the fully Available state through in-service testing.

**Availability State**
    The availability state of the host. It can be in one of the following
    states:

    **Offline**
        The host is known to |prod|, but is not reachable for maintenance
        purposes.

    **Online**
        The host is reachable and ready to be unlocked.

    **InTest**
        A transient state that occurs when transitioning from locked, or from
        a Failed operational state, to unlocked states. While in this state,
        the host is executing a series of tests to validate its hardware and
        software integrity.

    **Available**
        The host is fully operational and providing services.

    **Degraded**
        The host is experiencing compromised operational conditions, such as
        low memory, but is still providing the expected services. Details
        about the compromised conditions are available through the alarms
        subsystem.

.. xbooklink For more information, see |fault-doc|: `Fault Management <fault-management-overview>`.

    **Failed**
        A major fault has occurred and the host is no longer providing any
        services. The |prod| maintenance system automatically tries to
        recover hosts in this state.

        In the case of a worker node, any containers \(hosted applications\)
        that were running before are immediately restarted on another
        enabled worker node with sufficient available resources.

    **Power-off**
        The host is known to have been powered off by a previous maintenance
        action.

**Uptime**
    The uptime of the host, as reported by the system maintenance service.

**Status**
    An indicator of the immediate activity occurring on the host. It reports
    transitory steps such as booting, initializing, configuration out of
    date, and in-test, which a host goes through as it transitions from one
    administrative or availability state to another.

**Actions**
    The actions column presents an **Edit Host** button and a drop-down menu.

    The **Edit Host** button displays the Edit Host window, as illustrated
    below for a worker node:

    .. figure:: /node_management/kubernetes/figures/gkb1569351598356.png
        :scale: 100%

    This is the same window you use to assign the host's personality when
    installing the |prod| software on the host.

    -   The **Host Info** tab provides access for adding and modifying the
        Personality, Location, Host Name \(controller, worker and storage
        nodes only\), Clock Synchronization \(|NTP|/|PTP|\), and applying
        profiles.

        -   **Personality**: Select the personality or type of host.

        -   **Host Name**: Hostname of the host.

        -   **Location**: Type a physical location for the host to help
            identify the host.

        -   **Clock Synchronization**: Clock synchronization, |NTP| or |PTP|.
            The default is |NTP|.

        -   **Serial Console Data Carrier Detect**: Select this option to
            have any active console session automatically logged out when
            the serial console cable is disconnected. The server must support
            data carrier detect on the serial console port.

    -   The **Installation Parameters** tab provides access to installation
        settings. Changes take effect if the host is re-installed. For more
        information, see the document that pertains to your |prod|
        configuration.

    Next to the **Edit Host** button is a drop-down menu used for maintenance
    operations. The available operations depend on the host type and state.

    **Lock Host**
        Attempts to bring an unlocked host out of service. For more
        information, see :ref:`Lock a Host Using Horizon
        <locking-a-host-using-horizon>`.

    **Forced Lock Host**
        Forces an unlocked host to be out of service. For more information,
        see :ref:`Force Locking a Host Using Horizon
        <force-locking-a-host-using-horizon>`.

    **Swact Host**
        This operation is available on controller nodes only. It initiates a
        switch of the active/standby roles between two controllers. For more
        information, see :ref:`Swact Controllers Using Horizon
        <swacting-a-master-controller-using-horizon>`.

    **Unlock Host**
        Brings a locked host into service. For more information,
        see :ref:`Unlock a Host Using Horizon <unlocking-a-host-using-horizon>`.

    **Reboot Host**
        Gracefully restart a locked host, ensuring that all system processes
        are properly shut off first. For more information,
        see :ref:`Reboot a Host Using Horizon <rebooting-a-host-using-horizon>`.

    **Reinstall Host**
        Forces a full re-installation of the |prod| software on a locked
        host. The host's hard drive is erased, and the installation process
        is started afresh.

        For more information,
        see :ref:`Reinstall a Host Using Horizon <reinstalling-a-host-using-horizon>`.

    **Power Off Host**
        Gracefully powers off the host, ensuring that all system processes
        are properly shut off first. For more information,
        see :ref:`Power off a Host Using Horizon <powering-off-a-host-using-horizon>`.

        .. note::
            On a |prod| Simplex system, this function is not available.

    **Power On Host**
        Powers on the host. For more information,
        see :ref:`Power on a Host Using Horizon <powering-on-a-host-using-horizon>`.

        .. note::
            On a |prod| Simplex system, this function is not available.

    **Reset Host**
        Performs an out-of-band reset, stopping and restarting the host
        without ensuring that all system processes are shut off first. For
        more information, see :ref:`Reset a Host Using Horizon
        <resetting-a-host-using-horizon>`.

        Use this selection only if **Reboot Host** fails.

        .. note::
            On a |prod| Simplex system, this function is not available.

    **Delete Host**
        Removes the host from the inventory database, and erases its hard
        drive. For more information,
        see :ref:`Delete a Host Using Horizon <deleting-a-host-using-horizon>`.

    **Install Patches**
        Initiates any pending software update operations. Once successfully
        executed, the host returns back to the locked state.

.. xbookref See |updates-doc|:
        :ref:`Managing Software Updates <managing-software-updates>` for
        details.

        This option is only available if there are software update operations
        pending for the host.
