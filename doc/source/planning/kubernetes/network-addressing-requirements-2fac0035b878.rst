
.. zff1612526659434
.. _network-addressing-requirements-2fac0035b878:

===============================
Network Addressing Requirements
===============================

Network addressing requirements must be taken into consideration when planning
a |prod-long| installation.



.. _minimum_subnet_sizes-simpletable-kfn-qwk-nx:

.. FixMe: Replace with commented content below if code changes implemented.

.. only:: starlingx

   .. table::
       :widths: auto

       +------------------------------------+------------------------------------+------------------------------------+
       | Networks                           | Maximum prefix length              | Minimum number of addresses        |
       +====================================+====================================+====================================+
       | multicast and management           | 29                                 | 4                                  |
       +------------------------------------+------------------------------------+------------------------------------+
       | cluster-host, pxeboot, and OAM     | 29                                 | 3                                  |
       +------------------------------------+------------------------------------+------------------------------------+
       | cluster-pod and cluster-service    | 16                                 | 65336                              |
       +------------------------------------+------------------------------------+------------------------------------+  

.. only:: partner

   .. include:: /_includes/network-addressing-requirements-2fac0035b878.rest
