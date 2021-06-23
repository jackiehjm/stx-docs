
.. aiq1466089940954
.. _bootstrap-data:

==============
Bootstrap Data
==============

You can use one or more mechanisms to pass information to a new |VNF| when it
is originally launched. The |VNF| can use this information for system
configuration purposes or to determine running options for the services it
provides.

The mechanisms used to convey information from the Cloud OS to the |VNF| are
the metadata server and config drive.


.. _bootstrap-data-ul-aw2-l2d-3w:

-   User data is made available to the |VNF| through either the metadata
    service or the configuration drive.

-   The cloud-init package reads information from either the metadata
    server or the configuration drive.


Detailed information about the OpenStack metadata server, config drive, and
cloud-init is available online.

For more information, see `http://docs.openstack.org
<http://docs.openstack.org>`__.

