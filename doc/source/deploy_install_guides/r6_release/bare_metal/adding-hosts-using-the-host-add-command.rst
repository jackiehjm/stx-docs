
.. pyp1552927946441
.. _adding-hosts-using-the-host-add-command-r6:

================================
Add Hosts Using the Command Line
================================

You can add hosts to the system inventory using the :command:`host-add` command.

.. rubric:: |context|

There are several ways to add hosts to |prod|; for an overview, see the
StarlingX Installation Guides,
`https://docs.starlingx.io/deploy_install_guides/index.html
<https://docs.starlingx.io/deploy_install_guides/index.html>`_ for your
system. Instead of powering up each host and then defining its personality and
other characteristics interactively, you can use the :command:`system host-add`
command to define hosts before you power them up. This can be useful for
scripting an initial setup.

.. note::
    On systems that use static IP address assignment on the management network,
    new hosts must be added to the inventory manually and assigned an IP
    address using the :command:`system host-add` command. If a host is not
    added successfully, the host console displays the following message at
    power-on:

    .. code-block:: none

        This system has been configured with static management
        and infrastructure IP address allocation. This requires
        that the node be manually provisioned in System
        Inventory using the 'system host-add' CLI, GUI, or
        stx API equivalent.

.. rubric:: |proc|

#.  Add the host to the system inventory.

    .. note::
        The host must be added to the system inventory before it is powered on.

    On **controller-0**, acquire Keystone administrative privileges:

    .. code-block:: none

        $ source /etc/platform/openrc

    Use the :command:`system host-add` command to add a host and specify its
    personality. You can also specify the device used to display messages
    during boot.

    .. note::
        The hostname parameter is required for worker hosts. For controller and
        storage hosts, it is ignored.

    .. code-block:: none

        ~(keystone_admin)]$ system host-add  -n <hostname> \
        -p <personality>  [-s <subfunctions>] \
        [-l <location>] [-o <install_output>[-c <console>]] [-b <boot_device>] \
        [-r <rootfs_device>] [-m <mgmt_mac>] [-i <mgmt_ip>] [-D <ttys_dcd>] \
        [-T <bm_type> -I <bm_ip> -U <bm_username> -P <bm_password>]


    where

    **<hostname>**
        is a name to assign to the host. This is used for worker nodes only.
        Controller and storage node names are assigned automatically and
        override user input.

    **<personality>**
        is the host type. The following are valid values:

        -   controller

        -   worker

        -   storage

    **<subfunctions>**
        are the host personality subfunctions \(used only for a worker host\).

        For a worker host, the only valid value is worker,lowlatency to enable
        a low-latency performance profile. For a standard performance profile,
        omit this option.

        For more information about performance profiles, see |deploy-doc|:
        :ref:`Worker Function Performance Profiles
        <worker-function-performance-profiles>`.

    **<location>**
        is a string describing the location of the host

    **<console>**
        is the output device to use for message display on the host \(for
        example, tty0\). The default is ttys0, 115200.

    **<install\_output>**
        is the format for console output on the host \(text or graphical\). The
        default is text.

        .. note::
            The graphical option currently has no effect. Text-based
            installation is used regardless of this setting.

    **<boot\_device>**
        is the host device for boot partition, relative to /dev. The default is
        sda.

    **<rootfs\_device>**
        is the host device for rootfs partition, relative to/dev. The default
        is sda.

    **<mgmt\_mac>**
        is the |MAC| address of the port connected to the internal management
        or |PXE| boot network.

    **<mgmt\_ip>**
        is the IP address of the port connected to the internal management or
        |PXE| boot network, if static IP address allocation is used.

        .. note::
            The <mgmt\_ip> option is not used for a controller node.

    **<ttys\_dcd>**
        is set to **True** to have any active console session automatically
        logged out when the serial console cable is disconnected, or **False**
        to disable this behavior. The server must support data carrier detect
        on the serial console port.

    **<bm\_type>**
        is the board management controller type. Use bmc.

    **<bm\_ip>**
        is the board management controller IP address \(used for external
        access to board management controllers over the |OAM| network\)

    **<bm\_username>**
        is the username for board management controller access

    **<bm\_password>**
        is the password for board management controller access

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system host-add -n compute-0 -p worker -I 10.10.10.100

#.  Verify that the host has been added successfully.

    Use the :command:`fm alarm-list` command to check if any alarms (major or
    critical) events have occured. You can also type :command:`fm event-list`
    to see a log of events. For more information on alarms, see :ref:`Fault
    Management Overview <fault-management-overview>`.

#.  With **controller-0** running, start the host.

    The host is booted and configured with a personality.

#.  Verify that the host has started successfully.

    The command :command:`system host-list` shows a list of hosts. The
    added host should be available, enabled, and unlocked. You can also
    check alarms and events again.

.. rubric:: |postreq|

After adding the host, you must provision it according to the requirements of
the personality.

.. xbooklink For more information, see :ref:`Install, Configure, and Unlock
   Nodes <installing-configuring-and-unlocking-nodes>` and follow the *Configure*
   steps for the appropriate node personality.
