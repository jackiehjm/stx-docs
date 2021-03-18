
.. usq1569263366388
.. _uninstalling-cmk:

=============
Uninstall CMK
=============

You can uninstall the CPU Manager for Kubernetes from the command line.

.. rubric:: |proc|

#.  Delete **cmk**.

    .. code-block:: none

        % helm delete --purge cmk

    Wait for all pods in the terminating state to be deleted before proceeding.

#.  Delete **cmk-webhook**.

    .. code-block:: none

        % helm delete --purge cmk-webhook

    Wait for all pods in the terminating state to be deleted before proceeding.

#.  Delete **cmk-init**.

    .. code-block:: none

        % helm delete --purge cmk-init
