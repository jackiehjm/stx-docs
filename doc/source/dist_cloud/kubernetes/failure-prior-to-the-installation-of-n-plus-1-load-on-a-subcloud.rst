
.. uvp1597292940831
.. _failure-prior-to-the-installation-of-n-plus-1-load-on-a-subcloud:

===========================================================
Failure Prior to the Installation of N+1 Load on a Subcloud
===========================================================

You may encounter some errors prior to Installation of the **N+1** load on a
subcloud. This section explains the errors and the steps required to fix these
errors.

Errors can occur due to any one of the following:


.. _failure-prior-to-the-installation-of-n+1-load-on-a-subcloud-ul-onf-2vs-qmb:

-   Insufficient disk space on scratch filesystems

-   Missing subcloud install values

-   Invalid license

-   Invalid/corrupted load file

-   The /home/sysadmin directory on the subcloud is too large


If you encounter any of the above errors, follow this procedure to retry the
orchestrated upgrade after addressing the cause of failure:

.. rubric:: |proc|

#.  Delete the failed upgrade strategy

    .. code-block:: none

        ~(keystone_admin)]$  dcmanager upgrade-strategy delete

#.  Create a new upgrade strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy create <<additional options>>

    .. note::

        If only one subcloud fails the upgrade, specify the name of the
        subcloud in the command.

#.  Apply the new upgrade strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy apply

#.  Verify the upgrade strategy status

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step list
