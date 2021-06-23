
.. hfj1552920618138
.. _installing-in-service-software-updates-using-the-cli:

=================================================
Install In-Service Software Updates Using the CLI
=================================================

The procedure for applying an in-service update is similar to that of a
reboot-required update, except that the host does not need to be locked and
unlocked as part of applying the update.

.. rubric:: |proc|

#.  Upload the update \(patch\).

    .. code-block:: none

        $ sudo sw-patch upload INSVC_HORIZON_SYSINV.patch
        INSVC_HORIZON_SYSINV is now available

#.  Confirm that the update is available.

    .. code-block:: none

        $ sudo sw-patch query
              Patch ID        RR  Release  Patch State
        ====================  ==  =======  ===========
        INSVC_HORIZON_SYSINV  N    20.04    Available

#.  Check the status of the hosts.

    .. code-block:: none

        $ sudo sw-patch query-hosts
          Hostname      IP Address    Patch Current  Reboot Required  Release  State
        ============  ==============  =============  ===============  =======  =====
        worker-0      192.168.204.24       Yes             No          20.01   idle
        controller-0  192.168.204.3        Yes             No          20.01   idle
        controller-1  192.168.204.4        Yes             No          20.01   idle

#.  Ensure the original update files have been deleted from the root drive.

    After they are uploaded to the storage area, the original files are no
    longer required. You must use the command-line interface to delete them, in
    order to ensure enough disk space to complete the installation.

    .. code-block:: none

        $ rm </path/patchfile>

    .. caution::
        If the original files are not deleted before the updates are applied,
        the installation may fail due to a full disk.

#.  Apply the update \(patch\).

    .. code-block:: none

        $ sudo sw-patch apply INSVC_HORIZON_SYSINV
        INSVC_HORIZON_SYSINV is now in the repo

    The update state transitions to Partial-Apply:

    .. code-block:: none

        $ sudo sw-patch query
        Patch ID              RR  Release   Patch State
        ====================  ==  =======  =============
        INSVC_HORIZON_SYSINV  N    20.04   Partial-Apply

    As it is an in-service update, the hosts report that they are not 'patch
    current', but they do not require a reboot.

    .. code-block:: none

        $ sudo sw-patch query-hosts
        Hostname      IP Address      Patch Current  Reboot Required  Release  State
        ============  ==============  =============  ===============  =======  =====
        worker-0      192.168.204.24       No              No          20.04   idle
        controller-0  192.168.204.3        No              No          20.04   idle
        controller-1  192.168.204.4        No              No          20.04   idle
        

#.  Install the update on controller-0.

    .. code-block:: none

        $ sudo sw-patch host-install controller-0
        .............
        Installation was successful.

#.  Query the hosts to check status.

    .. code-block:: none

        $ sudo sw-patch query-hosts
        Hostname      IP Address    Patch Current  Reboot Required    Release  State
        ============  ==============  =============  ===============  =======  =====
        worker-0      192.168.204.24       No              No          20.01   idle
        controller-0  192.168.204.3        Yes             No          20.01   idle
        controller-1  192.168.204.4        No              No          20.01   idle

    The controller-1 host reports it is now 'patch current' and does not
    require a reboot, without having been locked or rebooted

#.  Install the update on worker-0 \(and other worker nodes and storage nodes,
    if present\)

    .. code-block:: none

        $ sudo sw-patch host-install worker-0
        ....
        Installation was successful.

    You can query the hosts to confirm that all nodes are now 'patch current',
    and that the update has transitioned to the Applied state.

    .. code-block:: none

        $ sudo sw-patch query-hosts
        Hostname      IP Address    Patch Current  Reboot Required  Release  State
        ============  ==============  =============  ===============  =======  =====
        worker-0      192.168.204.24       Yes             No          20.04   idle
        controller-0  192.168.204.3        Yes             No          20.04   idle
        controller-1  192.168.204.4        Yes             No          20.04   idle
        
        $ sudo sw-patch query
        Patch ID              RR  Release  Patch State
        ====================  ==  =======  ===========
        INSVC_HORIZON_SYSINV  N    20.04     Applied
