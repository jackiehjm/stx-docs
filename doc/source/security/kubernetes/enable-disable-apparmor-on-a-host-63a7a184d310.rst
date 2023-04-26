.. _enable-disable-apparmor-on-a-host-63a7a184d310:

=================================
Enable/Disable AppArmor on a Host
=================================

By default, AppArmor is disabled on a host. It can be enabled in the kernel
using system CLI commands as follows. In the below example AppArmor is enabled
on controller-0.

.. note::

    Enabling AppArmor can result in some performance degradation, see |org|
    System Engineering Guidelines.

.. note::

    On a multi-host configuration, AppArmor should be enabled on all hosts to
    ensure that the AppArmor profiles are loaded on any host where a pod may be
    scheduled by kubernetes.

#.  To enable AppArmor on a host, run the following commands:

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0
        ~(keystone_admin)]$ system host-update controller-0 apparmor=enabled
        ~(keystone_admin)]$ system host-unlock controller-0

    Wait for controller-0 to reset and return to an unlocked/enabled/available
    state.

#.  Verify if AppArmor is enabled by running the following commands on the
    host.

    .. code-block:: none

        sysadmin@controller-0:~$ aa-enabled

        Yes

To disable AppArmor on a host, run the following commands.

#.  In the below example AppArmor is disabled on controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0
        ~(keystone_admin)]$ system host-update controller-0 apparmor=disabled
        ~(keystone_admin)]$ system host-unlock controller-0

    Wait for controller-0 to reset and return to an unlocked/enabled/available
    state.

#.  Verify if AppArmor is disabled by running the following commands on the
    host.

    .. code-block:: none

        sysadmin@controller-0:~$ aa-enabled

        No
