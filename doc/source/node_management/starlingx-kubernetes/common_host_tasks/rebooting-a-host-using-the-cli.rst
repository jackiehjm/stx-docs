
.. swl1579724218236
.. _rebooting-a-host-using-the-cli:

===========================
Reboot a Host Using the CLI
===========================

Rebooting gracefully restarts a locked host, ensuring that all system
processes are properly shut off first.

The host then reboots automatically.

.. note::
    This function is not available on a |prod| Simplex system.

.. rubric:: |proc|


.. _rebooting-a-host-using-the-cli-steps-wlz-ksx-lkb:

-   Run the following command from the controller's command line.

    .. code-block:: none

        ~(keystone_admin)$ system host-reboot <hostname>
