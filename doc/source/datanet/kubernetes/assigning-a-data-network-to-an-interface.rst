
.. riw1559818822179
.. _assigning-a-data-network-to-an-interface:

=====================================
Assign a Data Network to an Interface
=====================================

In order to associate the L2 Network definition of a Data Network with a
physical network, the Data Network must be mapped to an interface on a host.

The command for performing the mapping has the format:

.. code-block:: none

    ~(keystone_admin)]$ system interface‐datanetwork‐assign <host\_name> <interface\_uuid> <datanetwork\_uuid>