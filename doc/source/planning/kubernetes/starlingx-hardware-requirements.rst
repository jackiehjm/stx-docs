
.. kdl1464894372485
.. _starlingx-hardware-requirements:

============================
System Hardware Requirements
============================

|prod| has been tested to work with specific hardware configurations. For
more information, see `Self Validated and Certified Hosts <https://www.windriver.com/studio/operator/self-validated-and-certified-hosts>`__.

.. contents:: |minitoc|
   :local:
   :depth: 1

If the minimum hardware requirements are not met, system performance cannot be
guaranteed.

.. _starlingx-hardware-requirements-section-N10044-N10024-N10001:

------------------
All-in-One Simplex
------------------

.. _starlingx-hardware-requirements-section-N102D0-N10024-N10001:

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: begin-min-hw-reqs-sx
   :end-before: end-min-hw-reqs-sx

-----------------
All-in-One Duplex
-----------------

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: begin-min-hw-reqs-dx
   :end-before: end-min-hw-reqs-dx

.. _starlingx-hardware-requirements-table-nvy-52x-p5:

--------
Standard
--------

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: begin-min-hw-reqs-std
   :end-before: end-min-hw-reqs-std

-------------------------------
Stardard with dedicated storage
-------------------------------

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: begin-min-hw-reqs-ded
   :end-before: end-min-hw-reqs-ded

.. _starlingx-hardware-requirements-section-if-scenarios:

---------------------------------
Interface configuration scenarios
---------------------------------

|prod| supports the use of consolidated interfaces for the management, cluster
host, and |OAM| networks. Some typical configurations are shown in the
following table. For best performance, |org| recommends dedicated interfaces.

|LAG| is optional in all instances.


.. _starlingx-hardware-requirements-table-if-scenarios:


.. table::
    :widths: auto

    +---------------------------------------------------------------------------+-------------------------------+-------------------------------+-------------------------------+
    | Scenario                                                                  | Controller                    | Storage                       | Worker                        |
    +===========================================================================+===============================+===============================+===============================+
    | -   Physical interfaces on servers limited to two pairs                   | 2x 10GE LAG:                  | 2x 10GE LAG:                  | 2x 10GE LAG:                  |
    |                                                                           |                               |                               |                               |
    | -   Estimated aggregate average Container storage traffic less than 5G    | -   Mgmt (untagged)           | -   Mgmt (untagged)           | -   Cluster Host (untagged)   |
    |                                                                           |                               |                               |                               |
    |                                                                           | -   Cluster Host (untagged)   | -   Cluster Host (untagged)   |                               |
    |                                                                           |                               |                               | Optionally                    |
    |                                                                           |                               |                               |                               |
    |                                                                           | 2x 1GE LAG:                   |                               | 2x 10GE LAG                   |
    |                                                                           |                               |                               |                               |
    |                                                                           | -   OAM (untagged)            |                               | external network ports        |
    +---------------------------------------------------------------------------+-------------------------------+-------------------------------+-------------------------------+
    | -   No specific limit on number of physical interfaces                    | 2x 1GE LAG:                   | 2x 1GE LAG                    | 2x 1GE LAG                    |
    |                                                                           |                               |                               |                               |
    | -   Estimated aggregate average Container storage traffic greater than 5G | -   Mgmt (untagged)           | -   Mgmt (untagged)           | -   Mgmt (untagged)           |
    |                                                                           |                               |                               |                               |
    |                                                                           |                               |                               |                               |
    |                                                                           | 2x 10GE LAG:                  | 2x 10GE LAG                   | 2x 10GE LAG:                  |
    |                                                                           |                               |                               |                               |
    |                                                                           | -   Cluster Host              | -   Cluster Host              | -   Cluster Host              |
    |                                                                           |                               |                               |                               |
    |                                                                           |                               |                               |                               |
    |                                                                           | 2x 1GE LAG:                   |                               | Optionally                    |
    |                                                                           |                               |                               |                               |
    |                                                                           | -   OAM (untagged)            |                               | 2x 10GE LAG                   |
    |                                                                           |                               |                               |                               |
    |                                                                           |                               |                               | -   external network ports    |
    |                                                                           | Optionally                    |                               |                               |
    |                                                                           |                               |                               |                               |
    |                                                                           | 2x 10GE LAG                   |                               |                               |
    |                                                                           |                               |                               |                               |
    |                                                                           | -   external network ports    |                               |                               |
    +---------------------------------------------------------------------------+-------------------------------+-------------------------------+-------------------------------+
