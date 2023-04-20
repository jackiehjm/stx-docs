
.. xqd1614091832213
.. _install-ptp-notifications:

=========================
Install PTP Notifications
=========================

|PTP| notification is packaged as a system application and is managed
using the :command:`system application` and :command:`system helm-override`
commands.

The application monitors time related services on a host and provides an API
for subscribing to asynchronous status notifications as well as the ability to
pull the state of each service on demand.

.. note::

    Changes to a node's |PTP| configuration, applied using the
    :command:`system ptp-instance-apply`, requires the ``ptp-notification``
    application to be removed and reapplied, using the
    :command:`system application-remove ptp-notification`, and
    :command:`system application-apply ptp-notification` commands.
    This allows the containers to reload the updated configuration files and
    monitor the services correctly.

**v1 API**

The legacy functionality of ``ptp-notification`` remains available and is
accessible through the v1 API; v1 is only capable of reporting status changes
for the |PTP| Sync State on a system.

**Limitations**

The v1 API only supports monitoring a single ``ptp4l + phc2sys`` instance.
Ensure the system is not configured with multiple instances when using the v1
API.

**v2 API**

The API conforms to O-RAN.WG6.O-Cloud Notification API-v02.01. Using the v2
API, multiple ``ptp4l`` instances can be tracked for independent |PTP| Sync
State and |PTP| Clock Class notifications.

The application monitors the following services:

-  PTP Sync State

-  PTP Clock Class

-  OS Clock Sync State

-  GNSS Sync State

-  Overall System Sync State


.. rubric:: |context|

|prod-long| provides the capability for application(s) to subscribe to
asynchronous |PTP| status notifications and pull for the |PTP| state on demand.

You must provide Helm override values indicating the ``ptp4l`` and ``phc2sys``
instances that you want tracked by your ``ptp-notification`` application.

Since multiple ``ptp4l`` instances can be supported on a node, you must specify
the ``ServiceName`` of the instance that the ``ptp-notification`` application
should track.

For example, follow the steps below:

.. rubric:: |proc|

#. Apply labels to nodes that will be running the ``ptp-notification``.

   #.  Apply the registration label to the controller nodes.

       .. code-block::

           ~(keystone_admin)]$ system host-label-assign controller-0 ptp-registration=true

   #.  Apply the notification label to each node that is configured for PTP
       clock synchronization.

       .. code-block::

           ~(keystone_admin)]$ system host-label-assign controller-0 ptp-notification=true
           ~(keystone_admin)]$ system host-label-assign compute-0 ptp-notification=true

   #.  Verify the labels.

       .. code-block::

           ~(keystone_admin)]$ system host-label-list <node name>

#.  Locate the application tarball on the system controller.

    .. code-block::

        ~(keystone_admin)]$ ls /usr/local/share/applications/helm/stx-ptp-notification-helm-2.<minor_version>.tgz

#. Upload the ``ptp-notification`` application using the command below.

   .. code-block::

       ~(keystone_admin)]$ system application-upload <path to application>

#.  Verify if the application is in the uploaded state.

    .. code-block::

       ~(keystone_admin)]$ system application-list

#.  Apply Helm overrides as required.

    .. code-block::

        ~(keystone_admin)]$ system helm-override-update ptp-notification ptp-notification notification --values notification-override.yaml

    You can override the default values for the ``ptp-notification`` application:

    #.  Create a yaml file and update the fields that require Helm overrides.

        .. code-block:: none

            ~(keystone_admin)]$ cat notification-override.yaml

            ptptrackingv2:
              enabled: True
              ptp4lServiceName: True
              phc2sysServiceName: True
              ts2phcServiceName: True
              log_level: INFO
              control_timeout: 2
              device:
                simulated: false
                holdover_seconds: 15
              osclock:
                holdover_seconds: 15
              overall:
                holdover_seconds: 15

        where the values are:

        **ptptracking**

        ptp4lServiceName: True

        phc2sysServiceName: True

        ts2phcServiceName: True

        -  The ServiceName fields are defaulted to True in the application and
           generally do not need to be altered.

        -  A service can be set to "False" in order to disable tracking for that
           type. However, if a service type is not configured on a node
           (ie. node does not use ts2phc), then the application will automatically
           determine this and not attempt to monitor it.

        -  Use these fields if there is a service that is configured on the node
           but you do NOT wish to track.

        **log_level: INFO**

        Set the logging level. DEBUG can be used for additional logs.

        **control_timeout: 2**

        control_timeout sets how frequently, in seconds the services are checked.
        Value applies to all service types.

        **device refers to ptp4l monitoring**

        device:
          holdover_seconds: 15
          poll_freq_seconds: 2
        osclock:
          holdover_seconds: 15
        overall:
          holdover_seconds: 15

        -  ``holdover_seconds`` configures how long each service will stay in the
           HOLDOVER state before transitioning to FREERUN. The holdover value
           used by the application equates to: holdover_seconds

        - (control_timeout * 2).

          This is done in order to account for time between the monitor polling
          cycles. The ``holdover_seconds`` value should be configured to match the
          validated holdover time provided by the device manufacturer.

    #.  To configure the ``ptp-notification`` v1 API, include the following in
        the ``notification-override.yaml`` file. Ensure that values are updated
        to match the configured instance names on your system.

        .. code-block:: none

            ptptracking:
              enabled: True
              ptp4lSocket: /var/run/ptp4l-instancename
              ptp4lServiceName: ptp4l-instancename
              phc2sysServiceName: phc2sys-instancename
              logging_level: INFO
            device:
              holdover_seconds: 15
              poll_freq_seconds: 2

    #.  View existing values.

        .. code-block:: none

            ~(keystone_admin)]$ system helm-override-show ptp-notification ptp-notification notification

    #.  Update and apply the values.

        Application values can be added by the user and applied, using the following commands.

        .. note::

            The application could be in the "uploaded" or "applied" state.

        .. code-block:: none

            ~(keystone_admin)]$ system helm-override-update ptp-notification ptp-notification notification -–values <notification-override.yaml>

            ~(keystone_admin)]$ system application-apply ptp-notification

#.  Verify the Helm overrides.

    .. code-block::

        ~(keystone_admin)]$ system helm-override-show ptp-notification ptp-notification notification

#.  Apply ``ptp-notification`` using the command below.

    .. code-block::

        ~(keystone_admin)]$ system application-apply ptp-notification


#.  Verify application status and pod status using the following commands:

    #.  Application Status

        .. code-block::

            ~(keystone_admin)]$ system application-list

    #.  Pod Status

        .. code-block::

            ~(keystone_admin)]$ kubectl get pods -n notification -o wide


.. rubric:: |postreq|

|prod-long| supports applications that rely on PTP for synchronization.
These applications are able to receive PTP status notifications from |prod-long|
hosting the application. For more information see:

-  :ref:`PTP Notifications Overview <ptp-notifications-overview>`

-  `API PTP Notifications <https://docs.starlingx.io/api-ref/ptp-notification-armada-app/api_ptp_notifications_definition_v1.html>`__

.. only:: partner

    .. include:: /_includes/install-ptp-notifications-3a94b1ea1ae3.rest
