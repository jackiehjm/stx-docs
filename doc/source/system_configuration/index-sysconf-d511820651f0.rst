.. _index-sysconf-d511820651f0:

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

   kubernetes/index-sysconf-kub-78f0e1e9ca5a

-------------------
StarlingX OpenStack
-------------------

.. os-begin

|prod-os| is installed and managed as an FluxCD application.

FluxCD applications are a set of one or more interdependent Application Helm
charts. In the case of |prod|, there is generally a Helm chart for every
OpenStack service.

.. os-end

.. toctree::
   :maxdepth: 3

   openstack/index-sysconf-os-988a21c687cb
