.. _sysconf_main_index:

.. only:: starlingx

   ====================
   System Configuration
   ====================

.. only:: partner

   ..include:: /_includes/title-overrides.rest
      :start-after: sysconf-title-begin
      :end-before: sysconf-title-end


--------------------
StarlingX Kubernetes
--------------------

|prod-long| system configuration can be done any time after installation
to change system configuration data specified during system installation,
and to set additional system configuration data.

.. toctree::
   :maxdepth: 2

   kubernetes/index.rst

-------------------
StarlingX OpenStack
-------------------

|prod-os| is installed and managed as an Armada application.

Armada Applications are a set of one or more interdependent Application Helm
Charts. In the case of |prod|, there is generally a Helm Chart for every
OpenStack service.

.. toctree::
   :maxdepth: 3

   openstack/index.rst
