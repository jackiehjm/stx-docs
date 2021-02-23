
.. xci1591728760242
.. _initiating-a-device-image-update-for-a-host:

=========================================
Initiate a Device Image Update for a Host
=========================================

To initiate device image updates on a host, use the
:command:`host-device-image-update` command.

.. note::
    Modifying or deleting device labels for devices on the host \(if any\)
    is not allowed while the update is in progress.

The command syntax is:

.. code-block:: none

    system host-device-image-update <hostname_or_host_ID>

.. rubric:: |eg|

-   To update a host image on controller-0, do the following:

    .. code-block:: none

        ~(keystone_user)$ system host-device-image-update controller-0
