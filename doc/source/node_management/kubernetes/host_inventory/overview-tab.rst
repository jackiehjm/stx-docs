
.. kdd1552674474497
.. _overview-tab:

============
Overview Tab
============

The **Overview** tab on the Host Detail page summarizes essential information
about a host object.

.. image:: /node_management/kubernetes/figures/pcd1567096217474.png
    :scale: 700



The following items are included in the summary:


.. _overview-tab-ul-mjj-fkz-l4:

-   host name, personality, and the internal UUID and host ID reference
    numbers

-   |MAC| and IP addresses on the internal management network

-   serial ID, if known. Use the following command to update it:

    .. code-block:: none

        $ system host-update <hostname> serialid=<xxx>

-   location, as entered by the operator using the Edit Host window
    \(see :ref:`Hosts Tab <hosts-tab>`\).

-   time stamps of when the host was created and last updated

-   the host's state

-   board management information, including controller type, |MAC| address,
    and IP address
