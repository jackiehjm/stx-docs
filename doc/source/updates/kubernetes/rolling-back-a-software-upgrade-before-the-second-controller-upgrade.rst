
.. wyr1593277734184
.. _rolling-back-a-software-upgrade-before-the-second-controller-upgrade:

=================================================================
Roll Back a Software Upgrade Before the Second Controller Upgrade
=================================================================

You can perform an in-service abort of an upgrade before the second Controller
\(controller-0 in the examples of this procedure\) have been upgraded.

.. rubric:: |proc|

#.  Abort the upgrade with the :command:`upgrade-abort` command.

    .. code-block:: none

        $ system upgrade-abort

    The upgrade state is set to aborting. Once this is executed, there is no
    canceling; the upgrade must be completely aborted.

    The following states apply when you execute this command.

    -   aborting:

        -   State entered when :command:`system upgrade-abort` is executed
            before upgrading controller-0.

        -   Remain in this state until the abort is completed.

#.  Make controller-0 active.

    .. code-block:: none

        $ system host-swact controller-1

    If controller-1 was active with the new upgrade release, swacting back to
    controller-0 will switch back to using the previous release databases,
    which were frozen at the time of the swact to controller-1. Any changes to
    the system that were made while controller-1 was active will be lost.

#.  Lock and downgrade controller-1.

    .. code-block:: none

        $ system host-lock controller-1
        $ system host-downgrade controller-1

    The host is re-installed with the previous release load.

#.  Unlock controller-1.

    .. code-block:: none

        $ system host-unlock controller-1
        
#.  Complete the upgrade.

    .. code-block:: none

        $ system upgrade-complete

#.  Delete the newer upgrade release that has been aborted.

    .. code-block:: none

        $ system load-delete <loadID>
