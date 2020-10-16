
.. eki1579789060117
.. _resetting-a-host-using-the-cli:

==========================
Reset a Host Using the CLI
==========================

A host can be reset out-of-band, stopping and restarting the host without
ensuring that all system processes are shut off first.

.. note::
    This function is not available on a |prod| Simplex system.

Use this selection only if the :command:`host-reboot` command fails.

.. rubric:: |prereq|

Board management must be configured on the system. For more information,
see :ref:`Provision Board Management Control Using the CLI <provisioning-board-management-control-using-the-cli>`.

.. rubric:: |proc|

-   Run the following command to power on a host from the controller's
    command line.

    .. code-block:: none

        ~(keystone_admin)$ system host-reset <hostname>
