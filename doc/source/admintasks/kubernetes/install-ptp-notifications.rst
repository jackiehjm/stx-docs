
.. xqd1614091832213
.. _install-ptp-notifications:

=========================
Install PTP Notifications
=========================

|PTP| notification is packaged as a system application and is managed
using the :command:`system application` and :command:`system-helm-override`
commands.

.. rubric:: |context|

|prod| provides the capability for application\(s\) to subscribe to
asynchronous |PTP| status notifications and pull for the |PTP| state on demand.

.. xbooklink :ref:`|prod-long| System Configuration
    <system-configuration-management-overview>`:

.. rubric:: |proc|

You must provide helm override values indicating the ``ptp4l`` and ``phc2sys``
instances being tracked by ``ptp-notification``.

You must also remove your existing ``ptp-notification`` application and
upload/apply the new version. Because multiple ``ptp4l`` instances can be
supported on a node, you must specify which instance ``ptp-notification`` is
tracking.


For example:


#. Upload ``ptp-notification``.

   .. code-block::

      ~(keystone_admin)]$ system application-upload <path to application>

#. Edit application overrides.

   .. code-block::

      cat ~/notification-override.yaml
      ptptracking:
        ptp4lSocket: /var/run/ptp4l-ptp1
        ptp4lServiceName: ptp1
        phc2sysServiceName: phc2sys1

#. Apply the overrides.

   .. code-block::

      ~(keystone_admin)]$ system helm-override-update ptp-notification ptp-notification notification --values notification-override.yaml

#. Apply ``ptp-notification``.

   .. code-block::

      ~(keystone_admin)]$ system application-apply ptp-notification
