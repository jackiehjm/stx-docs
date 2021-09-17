=======
Storage
=======

----------
Kubernetes
----------

.. kub-begin

|prod| uses storage resources on the controller and worker hosts, and on
storage hosts if they are present.The |prod| storage configuration is highly
flexible. The specific configuration depends on the type of system installed,
and the requirements of the system.

.. kub-end

.. toctree::
   :maxdepth: 2

   kubernetes/index

---------
OpenStack
---------

.. os-begin

|prod-os| is a containerized application running on top of the |prod-long|.

The storage management of hosts is not specific to |prod-os|.

.. os-end

.. toctree::
   :maxdepth: 2

   openstack/index