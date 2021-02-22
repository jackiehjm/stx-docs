
.. fcy1579787246250
.. _powering-off-a-host-using-the-cli:

==============================
Power off a Host Using the CLI
==============================

A host can be gracefully powered off using the controller's command line,
ensuring that all system processes are properly shut off first.

.. note::
    This function is not available on a |prod| Simplex system.

.. rubric:: |prereq|

Board management must be configured on the system. For more information,
see :ref:`Provision Board Management Control Using the CLI <provisioning-board-management-control-using-the-cli>`.

.. rubric:: |proc|

-   Run the following command to power off a host from the command line.

    .. code-block:: none

        ~(keystone_admin)$ system host-power-off <hostname>
