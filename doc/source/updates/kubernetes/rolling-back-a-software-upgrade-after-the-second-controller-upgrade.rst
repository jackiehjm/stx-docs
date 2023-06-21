
.. eiu1593277809293
.. _rolling-back-a-software-upgrade-after-the-second-controller-upgrade:

================================================================
Roll Back a Software Upgrade After the Second Controller Upgrade
================================================================

After the second controller is upgraded, you can still roll back a software
upgrade, however, the rollback will impact the hosting of applications.

The upgrade abort procedure can only be applied before the
:command:`upgrade-complete` command is issued. Once this command is issued
the upgrade cannot be aborted. If you must revert to the previous release,
then restore the system using the backup data taken prior to the upgrade.

In some scenarios additional actions will be required to complete the upgrade
abort. It may be necessary to restore the system from a backup.

.. rubric:: |proc|

#.  Run the :command:`upgrade-abort` command to abort the upgrade (running from
    controller-1).

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-abort

    Once this is done there is no going back; the upgrade must be completely
    aborted.

    The following state applies when you run this command.

    -   aborting-reinstall:

        -   State entered when :command:`system upgrade-abort` is executed
            after upgrading controller-0.

        -   Remain in this state until the abort is completed.

#.  Lock controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0

#.  Lock all storage and worker nodes that don't have ceph-mon configured
    (ceph-mon usually on worker-0 or storage-0). Execute the
    :command:`system ceph-mon-list` comand to determine which hosts are running
    ceph-mon.

    .. code-block:: none

        ~(keystone_admin)]$ system ceph-mon-list

    .. note::

        Skip this step if doing this procedure on a |prod| Duplex
        system.

#.  Use wipedisk on all worker and storage nodes, except on storage-0
    or on the worker node that has ceph-mon configured (worker-0 usually).

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

    #.  Execute :command:`wipedisk` from the shell on each storage or worker
        host.

    #.  Power down each host.

#.  Power off all storage and worker nodes except the node with ceph-mon.

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock <hostID>

#.  Downgrade controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-downgrade controller-0

    The host is re-installed with the previous release load.

#.  Unlock controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-0

    .. note::
        Wait for controller-0 to become unlocked-enabled. Wait for the
        |DRBD| sync 400.001 Services-related alarm to be raised and then cleared.

#.  Swact to controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-1

    Swacting back to controller-0 will switch back to using the previous
    release databases, which were frozen at the time of the swact to
    controller-1. This is essentially the same result as a system restore.

#.  Lock controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-1

    The host is re-installed with the previous release load.

#.  Downgrade controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-downgrade controller-1

#.  Unlock controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-1

#.  Run wipedisk on the worker node that was online (or the storage-0 node) and
    power off the host.

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

#.  Power up and unlock storage, then worker hosts one at a time.

    .. note::
        Skip this step if doing this procedure on a |prod| Duplex system.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock <hostID>

    The hosts are re-installed with the previous release load. As each worker
    host goes online, application pods will be automatically recovered by the
    system.

#.  Complete the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-abort-complete

    This cleans up the upgrade release, configuration, databases, and so forth.

#.  Delete the upgrade release load.

    .. code-block:: none

        ~(keystone_admin)]$ system load-delete
