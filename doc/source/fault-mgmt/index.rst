.. Fault Management file, created by
   sphinx-quickstart on Thu Sep  3 15:14:59 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

================
Fault Management
================

--------------------
StarlingX Kubernetes
--------------------

An admin user can view |prod-long| fault management alarms and logs in order
to monitor and respond to fault conditions.

You can access active and historical alarms, and customer logs using the CLI,
GUI, REST APIs and |SNMP|.

.. toctree::
   :maxdepth: 2

   kubernetes/index

-------------------
StarlingX OpenStack
-------------------

|prod-os| is a containerized application running on top of |prod|.

This section provides the list of OpenStack related Alarms and Customer Logs
that are monitored and reported for the |prod-os| application through the
|prod| fault management interfaces.

.. toctree::
   :maxdepth: 2

   openstack/index
