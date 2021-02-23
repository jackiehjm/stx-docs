
.. mwo1579724850160
.. _deleting-a-host-using-the-cli:

===========================
Delete a Host Using the CLI
===========================

Deleting removes the host from the inventory database, and erases its hard
drive.

.. note::
    This function is not available on a |prod| Simplex system.

.. rubric:: |proc|


.. _deleting-a-host-using-the-cli-steps-gtz-zvx-lkb:

-   Run the following command from the controller's command line.

    .. code-block:: none

        ~(keystone_admin)$ system host-delete <hostname>