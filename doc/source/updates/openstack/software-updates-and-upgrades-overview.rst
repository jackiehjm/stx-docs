
.. dqn1590002648435
.. _software-updates-and-upgrades-overview:

========
Overview
========

The system application-update -n |prefix|-openstack -v <new-app-version>
command is used for corrective content \(bug fixes\) -type updates to the
running containerized openstack application.

This means that the system application-update -n |prefix|-openstack is **not**
used for upgrading between OpenStack releases \(e.g. Train to Ussuri\). The
:command:`system application-update` assumes that there is no data schema
changes or data migration required in order to update to the new openstack
container image\(s\).

The system application-update -n |prefix|-openstack effectively performs a
helm upgrade of one or more of the OpenStack Helm chart releases within the
FluxCD Application. One or all of the containerized OpenStack deployments will
be updated according to their deployment specification.

.. note::
    Compute nodes do not need to be reset, and hosted application |VMs| are not impacted.

