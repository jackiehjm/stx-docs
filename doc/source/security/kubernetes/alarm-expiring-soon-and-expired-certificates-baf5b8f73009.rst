.. _alarm-expiring-soon-and-expired-certificates-baf5b8f73009:

============================================
Expiring-Soon and Expired Certificate Alarms
============================================

Expired certificates may prevent the proper operation of platform and
applications running on the platform. In order to avoid expired certificates,
|prod| generates alarms for certificates that are within 30 days (default) of
expiry or have already expired.

.. contents:: |minitoc|
   :local:
   :depth: 1

This functionality is enabled by default for all platform and user-installed
certificates that are approaching their respective expiry dates. User-override
options are available for customizing the alarm behavior.

The two types of certificate alarms are:

* ``Expiring Soon`` (alarm ID: 500.200, severity: major); by default raised 30
  days prior to expiry of the certificate.
* ``Expired`` (alarm ID: 500.210, severity: critical).

.. note::
   Certificates are checked every 24 hours to raise an Expiring-Soon or Expired
   alarm and alarms may not occur at precise 24 hour multiples of the times
   they were set.

.. code-block:: none

   [sysadmin@controller-0 ~(keystone_admin)]$ fm alarm-list
   +----------+------------------------------------------------------------------------------------------+--------------------------------------+----------+------------------+
   | Alarm ID | Reason Text                                                                              | Entity ID                            | Severity | Time Stamp       |
   +----------+------------------------------------------------------------------------------------------+--------------------------------------+----------+------------------+
   | 500.200  | Certificate 'system certificate-show 89b332d9-d590-4447-bf5a-6edc61c2d0e4' (mode=ssl_ca) | system.certificate.mode=ssl_ca.uuid= | major    | 2021-10-08T15:34 |
   |          | is expiring soon on 2021-10-15, 00:00:00                                                 | 89b332d9-d590-4447-bf5a-6edc61c2d0e4 |          | :49.451107       |
   |          |                                                                                          |                                      |          |                  |
   | 400.001  | Service group controller-services degraded; cert-alarm(enabled-active, )                 | service_domain=controller.           | major    | 2021-10-08T15:34 |
   |          |                                                                                          | service_group=controller-services.   |          | :27.494473       |
   |          |                                                                                          | host=controller-0                    |          |                  |
   |          |                                                                                          |                                      |          |                  |
   | 100.103  | Memory threshold exceeded ; threshold 80.00%, actual 81.12%                              | host=controller-0.memory=platform    | major    | 2021-10-08T00:21 |
   |          |                                                                                          |                                      |          | :25.237489       |
   |          |                                                                                          |                                      |          |                  |
   +----------+------------------------------------------------------------------------------------------+--------------------------------------+----------+------------------+

The platform monitors the following resources to track and audit certificate
expiry dates:

* All |TLS| type secrets in all Kubernetes namespaces.

  This includes secrets that you create directly or secrets that are indirectly
  created by configuring a Cert-Manager certificate.

* All certificates installed on the platform via the :command:`system
  certificate-install` command.

* Other internal certificates required by the platform such as Kubernetes
  RootCA, Etcd RootCA etc.

  .. note::

     For certificates managed by cert-manager, the expiring soon alarm is not
     generated unless the certificate's ``renewBefore`` date is past.  In this
     way, alarms for certificates auto-renewed by cert-manager, will only occur
     if the renew failed.

Overriding Default Certificate Alarming Behavior
================================================

For certificates that exist under the Kubernetes domain, Kube Annotations can
be used to override the default certificate alarming behavior. All other
certificate types only support default certificate alarming behavior and cannot
be overridden.

.. note::

   If you added a certificate by directly creating a Kubernetes |TLS| Secret,
   the annotation should be added to that Kubernetes Secret resource. If the
   Secret was indirectly created by configuring a Cert-Manager certificate
   resource, the annotation should be added to the certificate resource.

The supported annotations are:

*    ``starlingx.io/alarm: <enabled | disabled>`` (default=enabled)

*    ``starlingx.io/alarm-before: <days>`` (default=30d)

*    ``starlingx.io/alarm-severity: <critical/major/minor>``

*    ``starlingx.io/alarm-text: <pre-text in alarm description>``


.. rubric:: |eg|

If the ``system-restapi-gui-certificate`` has been configured to install the
StarlingX RESTAPI / Webserver certificate to be managed by Cert-Manager, the
default annotations can be edited:

#. Open the current configuration:

   .. code-block:: none

      $ kubectl edit certificate system-restapi-gui-certificate -n deployment

#. Make the following configuration changes:

   .. code-block:: none

      metadata:

        annotations:

          starlingx.io/alarm: enabled

          starlingx.io/alarm-before: 15d

          starlingx.io/alarm-severity: minor

          starlingx.io/alarm-text: “webserverAPI certificate”

These override settings cause the ``system-restapi-gui-certificate`` resource
to be monitored via the ``alarm: enabled`` annotation. An alarm will be raised
15 days before the certificate expiry if the certificate is soon-to-expire or
has expired with a minor severity. The alarm text will be prefixed with the
string ``webserverAPI certificate``, resulting in ``webserverAPI certificate
namespace=deployment.certificate=system-restapi-gui-certificate is expiring
soon on <date>``.

Corrective action
=================

When a certificate alarm occurs, the resource should be updated in order to
clear the alarm. If the certificate was installed via the :command:`system
certificate-install` command, a new certificate needs to be obtained and
re-installed. For certificates that are managed by Cert-Manager, the
certificates will auto-renew provided there are no configuration errors; list
issues with cert-manager auto-renewal of a certificate with :command:`kubectl
-n <namespace> describe certificate <certname>`.

.. note::

   It may take up to one hour for an active alarm to clear after corrective
   action has been taken.

.. seealso::

  :ref:`500-series-alarm-messages`
