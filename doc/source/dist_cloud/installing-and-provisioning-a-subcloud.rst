
.. vdh1580229514829
.. _installing-and-provisioning-a-subcloud:

===================================
Install and Provisioning a Subcloud
===================================

You can install and provision a subcloud with or without using the Redfish
Platform Management Service.

.. include:: ../_includes/installing-and-provisioning-a-subcloud.rest
   :start-after: begin-redfish-vms
   :end-before: end-redfish-vms

.. note::

    Each subcloud must be on a separate management subnet \(different from the
    SystemController and from any other subclouds\).


.. _installing-and-provisioning-a-subcloud-section-orn-jkf-t4b:

.. only:: partner

    .. include:: ../_includes/installing-and-provisioning-a-subcloud.rest
       :start-after: begin-shared-nic
       :end-before: end-shared-nic
