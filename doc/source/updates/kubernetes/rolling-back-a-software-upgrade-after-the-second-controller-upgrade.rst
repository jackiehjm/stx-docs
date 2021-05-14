
.. eiu1593277809293
.. _rolling-back-a-software-upgrade-after-the-second-controller-upgrade:

================================================================
Roll Back a Software Upgrade After the Second Controller Upgrade
================================================================

After the second controller is upgraded, you can still roll back a software
upgrade, however, the rollback will impact the hosting of applications.

.. rubric:: |proc|

#.  Run the :command:`upgrade-abort` command to abort the upgrade.

    .. code-block:: none

        $ system upgrade-abort

    Once this is done there is no going back; the upgrade must be completely
    aborted.

    The following state applies when you run this command.

    -   aborting-reinstall:

        -   State entered when :command:`system upgrade-abort` is executed
            after upgrading controller-0.

        -   Remain in this state until the abort is completed.

#.  Make controller-1 active.

    .. code-block:: none

        $ system host-swact controller-0

#.  Lock controller-0.

    .. code-block:: none

        $ system host-lock controller-0

#.  Wipe the disk and power down all storage \(if applicable\) and worker hosts.

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

    #.  Execute :command:`wipedisk` from the shell on each storage or worker
        host.

    #.  Power down each host.

#.  Lock all storage \(if applicable\) and worker hosts.

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

    .. code-block:: none

        $ system host-lock <hostID>

#.  Downgrade controller-0.

    .. code-block:: none

        $ system host-downgrade controller-0

    The host is re-installed with the previous release load.

#.  Unlock controller-0.

    .. code-block:: none

        $ system host-unlock controller-0

#.  Swact to controller-0.

    .. code-block:: none

        $ system host-swact controller-1

    Swacting back to controller-0 will switch back to using the previous
    release databases, which were frozen at the time of the swact to
    controller-1. This is essentially the same result as a system restore.

#.  Lock and downgrade controller-1.

    .. code-block:: none

        $ system host-downgrade controller-1

    The host is re-installed with the previous release load.

#.  Unlock controller-1.

    .. code-block:: none

        $ system host-unlock controller-1
        

#.  Power up and unlock the storage hosts one at a time \(if using a Ceph
    storage backend\). The hosts are re-installed with the release N load.

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

#.  Power up and unlock the worker hosts one at a time.

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

    The hosts are re-installed with the previous release load. As each worker
    host goes online, application pods will be automatically recovered by the
    system.

#.  Complete the upgrade.

    .. code-block:: none

        $ system upgrade-complete

    This cleans up the upgrade release, configuration, databases, and so forth.

#.  Delete the upgrade release load.

    .. code-block:: none

        $ system load-delete
