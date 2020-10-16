
.. txs1591808441234
.. _listing-device-labels:

==================
List Device Labels
==================

Use the :command:`host-device-label-list` command to review device labels
used on a host.

The command format is:

.. code-block:: none

    system host-device-label-list <hostname_or_id> <devicename_or_address>

.. rubric:: |eg|

-   To list device labels on controller-0, do the following.

    .. code-block:: none

        ~(keystone_admin)$ system host-device-label-list controller-0
        +--------------+------------------+-----------+-------------+
        | hostname     | PCI device name  | label key | label value |
        +--------------+------------------+-----------+-------------+
        | controller-0 | pci_0000_b3_00_0 | key1      | value1      |
        +--------------+------------------+-----------+-------------+
