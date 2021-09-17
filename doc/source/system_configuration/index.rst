.. _sysconf_main_index:

====================
System Configuration
====================


--------------------
StarlingX Kubernetes
--------------------

.. kub-begin

|prod-long| system configuration can be done any time after installation
to change system configuration data specified during system installation,
and to set additional system configuration data.

.. kub-end

.. toctree::
   :maxdepth: 2

   kubernetes/index.rst

-------------------
StarlingX OpenStack
-------------------

.. os-begin

|prod-os| is installed and managed as an Armada application.

Armada Applications are a set of one or more interdependent Application Helm
charts. In the case of |prod|, there is generally a Helm chart for every
OpenStack service.

.. os-end

.. toctree::
   :maxdepth: 3

   openstack/index.rst
