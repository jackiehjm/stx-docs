
.. wyr1593277734184
.. _rolling-back-a-software-upgrade-before-the-second-controller-upgrade:

=================================================================
Roll Back a Software Upgrade Before the Second Controller Upgrade
=================================================================

After the first controller is upgraded, you can still perform an in-service
abort of an upgrade before the second Controller \(controller-0 in the examples
of this procedure\) has been upgraded. The :command:`system upgrade-abort`
command can be run from the node that is updated with the latest release and
has upgraded successfully.

.. rubric:: |proc|

#.  Abort the upgrade with the :command:`upgrade-abort` command.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-abort

    The upgrade state is set to aborting. Once this is executed, there is no
    canceling; the upgrade must be completely aborted.

    The following states apply when you execute this command.

    -   aborting:

        -   State entered when :command:`system upgrade-abort` is executed
            before upgrading controller-0.

        -   Remain in this state until the abort is completed.

#.  Make controller-0 active.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-1

    If controller-1 was active with the new upgrade release, swacting back to
    controller-0 will switch back to using the previous release databases,
    which were frozen at the time of the swact to controller-1. Any changes to
    the system that were made while controller-1 was active will be lost.

#.  Lock and downgrade controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-1
        ~(keystone_admin)]$ system host-downgrade controller-1

    The host is re-installed with the previous release load.

    .. note::
        The downgrade process will take a minimum of 20 to 30 minutes to
        complete.

        You can view the downgrade progress on controller-1 using the
        serial console.

#.  Unlock controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-1

#.  Complete the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-complete

#.  Delete the newer upgrade release that has been aborted.

    .. code-block:: none

        ~(keystone_admin)]$ system load-delete <loadID>
