
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

You must provide Helm override values indicating the ``ptp4l`` and ``phc2sys``
instances that you want tracked by your ``ptp-notification`` application.

Since multiple ``ptp4l`` instances can be supported on a node, you must specify
the ``ServiceName`` of the instance that the ``ptp-notification`` application
should track.


For example, follow the steps below:

#. Label the controller(s).

   #.  Source the platform environment.

       .. code-block::

          $ source /etc/platform/openrc
          ~(keystone_admin)]$

   #.  Assign the |PTP| registration label to the controller(s).

       .. code-block::

           ~(keystone_admin)]$ system host-label-assign controller-0 ptp-registration=true
           ~(keystone_admin)]$ system host-label-assign controller-1 ptp-registration=true

   #.  Assign the |PTP| notification label to any node(s) configured for ``ptp4l``
       clock synchronization. For example:

       .. code-block::

           ~(keystone_admin)]$ system host-label-assign controller-0 ptp-notification=true

#. Upload the ``ptp-notification`` application using the command below.

   .. code-block::

       ~(keystone_admin)]$ system application-upload <path to application>

#. Edit application overrides. The value for ``ptp4lSocket`` should be set to
   the socket path corresponding to the monitored ``ptp4l`` instance. Use the
   :command:`ls /var/run/ptp4l-*` command to determine this path. The value for
   ``ptp4lServiceName`` should match the ``ptp4l`` instance name. The value for
   the ``phc2sysServiceName`` should match the ``phc2sys`` instance name. Use
   the :command:`system ptp-instance-list` command to determine the values for
   ``ptp4lServiceName`` and ``phc2sysServiceName`` names.

   .. code-block::

      cat ~/notification-override.yaml
      ptptracking:
        ptp4lSocket: /var/run/ptp4l-ptp1
        ptp4lServiceName: ptp1
        phc2sysServiceName: phc2sys1

#. Apply the overrides using the command below.

   .. code-block::

       ~(keystone_admin)]$ system helm-override-update ptp-notification ptp-notification notification --values notification-override.yaml

#. Apply ``ptp-notification`` using the command below.

   .. code-block::

       ~(keystone_admin)]$ system application-apply ptp-notification

.. rubric:: |postreq|

StarlingX supports applications that rely on PTP for synchronization.
These applications are able to receive PTP status notifications from StarlingX
hosting the application. For more information see:

-  :ref:`PTP Notifications Overview <ptp-notifications-overview>`

-  `API PTP Notifications <https://docs.starlingx.io/api-ref/ptp-notification-armada-app/api_ptp_notifications_definition_v1.html>`__
