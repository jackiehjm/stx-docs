
.. xpx1579702157578
.. _500-series-alarm-messages:

=========================
500 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: /_includes/x00-series-alarm-messages.rest

.. _500-series-alarm-messages-table-zrd-tg5-v5:


-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 500.101**
     - Developer patch certificate enabled.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C
   * - Proposed Repair Action
     - Reinstall system to disable developer certificate and remove untrusted
       patches.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 500.200**
     - Certificate ‘system certificate-show <uuid>' (mode=<ssl/ssl_ca/docker_registry/openstack/openstack_ca>) expiring soon on <date>.
       OR
       Certificate ‘<Namespace>/<Certificate/Secret>’ expiring soon on <date>.
       OR
       Certificate ‘<k8sRootCA/EtcdCA>’ expiring soon on <date>.
       system.certificate.k8sRootCA
   * - Entity Instance
     - system.certificate.mode=<mode>.uuid=<uuid>
       OR
       namespace=<namespace-name>.certificate=<certificate-name>
       OR
       namespace=<namespace-name>.secret=<secret-name>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Proposed Repair Action
     - Renew certificate for the entity identified.
   * - Management_Affecting_Severity:
     - none

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 500.210**
     - Certificate ‘system certificate-show <uuid>' (mode=<ssl/ssl_ca/docker_registry/openstack/openstack_ca>) expired.
       OR
       Certificate ‘<Namespace>/<Certificate/Secret>’ expired.
       OR
       Certificate ‘<k8sRootCA/EtcdRootCA>’ expired.
   * - Entity Instance
     - system.certificate.mode=<mode>.uuid=<uuid>
       OR
       namespace=<namespace-name>.certificate=<certificate-name>
       OR
       namespace=<namespace-name>.secret=<secret-name>
       OR
       system.certificate.k8sRootCA
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C
   * - Proposed Repair Action
     - Renew certificate for the entity identified.
   * - Management_Affecting_Severity:
     - none
