
.. arg1579723792964
.. _unlocking-a-host-using-the-cli:

===========================
Unlock a Host Using the CLI
===========================

Unlocking a host brings a locked host into service.

.. rubric:: |context|

Unlocking first resets the target host to ensure that it starts from a
well-known state. The host is then automatically configured, and any required
software patches are applied.

The state transition only succeeds if all the necessary configuration
components for the host are already in place.

During the unlock operation, the host is rebooted. If the boot process
fails, a second reboot is attempted. For some types of boot failure, the
number of successive reboot attempts is limited; for more information,
see :ref:`Reboot Limits for Host Unlock <reboot-limits-for-host-unlock>`.

.. note::
    On a |prod| Simplex system, any containers \(hosted applications\)
    that were stopped by the preceding :command:`host-lock` operation are
    started automatically.

.. rubric:: |proc|

-   Run the following command from the controller's command line.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock <hostname>
