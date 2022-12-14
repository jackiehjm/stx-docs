
.. nko1614009294405
.. _ptp-notifications-overview:

==========================
PTP Notifications Overview
==========================

|prod-long| provides ``ptp-notification`` to support applications that rely on
|PTP| for time synchronization and require the ability to determine if the system
time is out of sync. ``ptp-notification`` provides the ability for user applications
to query the sync state of hosts as well as subscribe to push notifications for
changes in the sync status.

|prod-long| provides a Sidecar, which runs with the hosted application in the
same pod and communicates with the application via a REST API.

PTP-notification consists of two main components:

-  The ``ptp-notification`` system application can be installed on nodes
   using |PTP| clock synchronization. This monitors the various time services
   and provides the v1 and v2 REST API for clients to query and subscribe to.

-  The ``ptp-notification`` sidecar. This is a container image which can be
   configured as a sidecar and deployed alongside user applications that wish
   to use the ``ptp-notification`` API. User applications only need to be
   aware of the sidecar, making queries and subscriptions via its API.
   The sidecar handles locating the appropriate ``ptp-notification`` endpoints,
   executing the query and returning the results to the user application.

.. _ptp-notifications-overview-ul-ggf-x1f-t4b:

|prod-long| supports the following features:

-   Provides the capability to enable application(s) subscribe to |PTP| status
    notifications and pull for the |PTP| state on demand.

-   Uses a REST API to communicate |PTP| notifications to the application.

-   Enables operators to install the **ptp-notification-armada-app**, Sidecar
    container, and the application supporting the REST API. For more information,
    see, `https://docs.starlingx.io/api-ref/ptp-notification-armada-app/index.html
    <https://docs.starlingx.io/api-ref/ptp-notification-armada-app/index.html>`__.

-   Supports the **ptp4l** module and |PTP| port that is configured in
    Subordinate mode (Secondary mode).

-   The |PTP| notification Sidecar container can be configured with a Liveness
    Probe, if required. See, :ref:`Liveness Probe <liveness-probe>` for more
    information.

.. _ptp-notifications-overview-simpletable-n1r-dcf-t4b:

---------------------------------------
Differences between v1 and v2 REST APIs
---------------------------------------

Use of the v1 and v2 APIs is distinguished by the version identifier in the
URI when interacting with the sidecar container. Both are always available.
For example:

**v1 API**

-  /ocloudNotifications/v1/subscriptions

-  /ocloudNotifications/v2/subscriptions

The v1 API is maintained for backward compatibility with existing deployments.
New deployments should use the v2 API.

**v1 Limitations**

-  Support for monitoring a single ``ptp4l`` instance per host - no other services
   can be queried/subscribed to.

-  API does not conform to the O-RAN.WG6.O-Cloud Notification API-v02.01
   standard.

See the respective ``ptp-notification`` v1 and v2 document subsections for
details on the behaviour.

**Integrated Containerized Applications**

-   Applications that rely on |PTP| for synchronization have the ability to
    retrieve the relevant data for the status of the monitored service. User
    applications may subscribe to notifications from multiple service types
    and from multiple separate nodes.

-   Once an application subscribes to |PTP| notifications it receives the initial
    data that shows the service state, and receives notifications when there is
    a state change to the sync status and/or per request for notification (pull).

The figure below describes the subscription framework for |PTP| notifications.

.. image:: figures/gvf1614702096862.png
   :width: 500

**Liveness Probe**

.. _liveness-probe:

The |PTP| notification Sidecar container can be configured with a Liveness
probe, if required. You can edit the Sidecar values in the deployment
manifest to include these parameters.

.. note::
    Port and timeout values can be configured to meet user preferences.

.. code-block:: none

    cat <<EOF >
    items:
    spec:
      template:
        spec:
          containers:
            livenessProbe:
              exec:
                command:
                - timeout
                - "2"
                - curl
                - http://127.0.0.1:8080/health
              failureThreshold: 3
              periodSeconds: 3
              successThreshold: 1
              timeoutSeconds: 3
    EOF

