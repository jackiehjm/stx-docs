
.. yxg1614092306444
.. _integrate-the-application-with-notification-client-sidecar:

==========================================================
Integrate the Application with Notification Client Sidecar
==========================================================

.. only:: partner

   .. include:: /_includes/integrate-application-with-notification-client-sidecar.rest
      :start-after: shortdesc-begin
      :end-before: shortdesc-end

.. rubric:: |context|

This section provides an example of kubernetes deployment of the sidecar and a
simulated application. Users could replace the ``ptp-notification-demo-app``
container and related configurations with an application requiring |PTP| status
updates. The user application must support querying and handling responses
for either of the API definitions available at:

**See**:

-  https://docs.starlingx.io/api-ref/ptp-notification-armada-app/api_ptp_notifications_definition_v1.html

-  https://docs.starlingx.io/api-ref/ptp-notification-armada-app/api_ptp_notifications_definition_v2.html


.. Cole please confirm if this is required

The integration between the application is done with the use of a Sidecar. The
Sidecar runs as a container along with the application in the same pod. The
application and the Sidecar communicate via a REST API. See the figure below.

.. only:: partner

   .. include:: /_includes/integrate-application-with-notification-client-sidecar.rest
      :start-after: note-begin
      :end-before: note-end

To use the v1 API, deploy ``starlingx/notificationclient-base:stx.5.0-v1.0.4``
as the sidecar container.

To use the v2 API, deploy ``starlingx/notificationclient-base:stx.9.0-v2.1.1``
as the sidecar container.

.. rubric:: |prereq|

The following prerequisites are required before the integration:

.. only:: partner

   .. include:: /_includes/integrate-application-with-notification-client-sidecar.rest
      :start-after: prereq-begin
      :end-before: prereq-end

-   The cloud is configured with a node that supports the Subordinate mode (Secondary mode).

-   The cloud is labeled with **ptp-registration=true**, and **ptp-notification=true**.

-   The **ptp-notification-armada-app** application is installed successfully.

-   The application supports the |PTP| Notifications API.


The config provided below is for illustrative purposes and is not validated.
A suitable user-supplied container would have to be run in the same pod and
configured to make API calls to the notificationclient-base container.

.. parsed-literal::

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ptp-notification-example
      namespace: ptpexample
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: ptp-notification-example
      template:
        metadata:
          namespace: ptpexample
          labels:
            app: ptp-notification-example
            release: RELEASE-NAME
        spec:
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: ptp-notification
                    operator: In
                    values:
                    - "true"
           containers:
             - name: ptp-notification-demo-sidecar
               image: "starlingx/notificationclient-base:|v_starlingx-notificationclient-base|"
               imagePullPolicy: IfNotPresent
               tty: true
               stdin: true
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
            env:
              - name: THIS_NODE_NAME
                valueFrom:
                  fieldRef:
                    fieldPath: spec.nodeName
              - name: THIS_POD_IP
                valueFrom:
                  fieldRef:
                    fieldPath: status.podIP
              - name: REGISTRATION_HOST
                value: "registration.notification.svc.cluster.local"
              - name: REGISTRATION_USER
                value: "admin"
              - name: REGISTRATION_PASS
                value: "admin"
              - name: REGISTRATION_PORT
                value: "5672"
              - name: NOTIFICATIONSERVICE_USER
                value: "admin"
              - name: NOTIFICATIONSERVICE_PASS
                value: "admin"
              - name: NOTIFICATIONSERVICE_PORT
                value: "5672"
              - name: SIDECAR_API_PORT
                value: "8080"
              - name: DATASTORE_PATH
                value: "/opt/datastore"
              - name: LOGGING_LEVEL
                value: "INFO"
            command: ["/bin/bash", "/mnt/sidecar_start.sh"]
            volumeMounts:
              - name: scripts
                mountPath: /mnt
              - name: data-volume
                mountPath: /opt/datastore
            resources:
              requests:
                cpu: 50m
                memory: 128Mi
              limits:
                cpu: 300m
                memory: 256Mi
        imagePullSecrets:
          - name: admin-registry-secret

-----------------
Example API Calls
-----------------

Below are examples of using curl to interact with the ``ptp-notification`` API.
These can be used to validate the functionality of the application deployment.

.. note::

   Some versions of curl have been seen to automatically normalize URLs
   which results in malformed requests to the server by removing parts of the
   URL containing '/././' or '/./'

If the version of curl being used supports the flag '--path-as-is' then it
should be included in the command to avoid this behaviour.

**v1 Examples**

.. code-block:: none

    # pull

    curl --path-as-is -v -H 'Content-Type: application/json'
    http://127.0.0.1:8080/ocloudNotifications/v1/PTP/CurrentState |
    python -m json.tool

    # subscribe

    curl --path-as-is -v -d '{"ResourceType": "PTP", "ResourceQualifier":
    {"NodeName":"controller-0"}, "EndpointUri": "http://127.0.0.1:9090/v1/resource_status/ptp"}'
    -H 'Content-Type: application/json' -X POST http://127.0.0.1:8080/ocloudNotifications/v1/subscriptions
    |python -m json.tool
    curl --path-as-is -v -d '{"ResourceType": "PTP", "ResourceQualifier":
    {"NodeName":"controller-1"}, "EndpointUri": "http://127.0.0.1:9090/v1/resource_status/ptp"}'
    -H 'Content-Type: application/json' -X POST http://127.0.0.1:8080/ocloudNotifications/v1/subscriptions
    |python -m json.tool

    # get subscriptions

    curl --path-as-is -v -H 'Content-Type: application/json'
    http://127.0.0.1:8080/ocloudNotifications/v1/subscriptions |python -m json.tool

    # get one subscription

    # must supply the subscription ID found in "get subscriptions"

    curl --path-as-is -v -H 'Content-Type: application/json'
    http://127.0.0.1:8080/ocloudNotifications/v1/subscriptions/<subscription id> |
    python -m json.tool

    # unsubscribe
    # must supply the subscription ID found in "get subscriptions"
    curl --path-as-is -X DELETE -v -H 'Content-Type: application/json'
    http://127.0.0.1:8080/ocloudNotifications/v1/subscriptions/df71709c-9fff-11ec-bf54-6aa223637e5f


**v2 Examples**

Some commands can target the status of specific node names or of specific ``ptp4l``
instances. The names in the format <name> will vary depending on the user's
environment.

The "| python -m json.tool" portion of the command is just for output
formatting and is not required for operation.

Requests with the "/././" path with be automatically directed to the
``ptp-notification`` server on the local node, while providing "/./<node name>"
will route to the specified node

.. code-block:: none

   ## pull

   # overall

   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/././sync/sync-status/sync-state/CurrentState |
   python -m json.tool
   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/./<node name>/sync/sync-status/sync-state/CurrentState |
   python -m json.tool

   # ptp state

   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/././sync/ptp-status/lock-state/CurrentState |
   python -m json.tool
   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/./<node name>/sync/ptp-status/lock-state/CurrentState |
   python -m json.tool
   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/./<node name>/<ptp instance name>/sync/ptp-status/lock-state/CurrentState |
   python -m json.tool

   # ptp class

   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/././sync/ptp-status/clock-class/CurrentState |
   python -m json.tool
   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/./<node name>/sync/ptp-status/clock-class/CurrentState |
   python -m json.tool
   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/./<node name>/<ptp instance name>/sync/ptp-status/clock-class/CurrentState |
   python -m json.tool

   # phc2sys / os clock state

   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/././sync/sync-status/os-clock-sync-state/CurrentState |
   python -m json.tool
   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/./<node name>/sync/sync-status/os-clock-sync-state/CurrentState |
   python -m json.tool

   # gnss

   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/././sync/gnss-status/gnss-sync-status/CurrentState |
   python -m json.tool
   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:8080/ocloudNotifications/v2/./<node name>/sync/gnss-status/gnss-sync-status/CurrentState |
   python -m json.tool

   ## subscribe

   # subscribe overall

   curl --path-as-is -v -d '{"ResourceAddress": "/././sync/sync-status/sync-state", "EndpointUri":
   "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type: application/json' -X POST
   http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool
   curl --path-as-is -v -d '{"ResourceAddress": "/./<node name>/sync/sync-status/sync-state",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type:
   application/json' -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool

   # subscribe PTP lock state

   curl --path-as-is -v -d '{"ResourceAddress": "/././sync/ptp-status/lock-state",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type: application/json'
   -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool
   curl --path-as-is -v -d '{"ResourceAddress": "/./<node name>/sync/ptp-status/lock-state",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type: application/json'
   -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool

   # subscribe PTP clock class

   curl --path-as-is -v -d '{"ResourceAddress": "/././sync/ptp-status/clock-class",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}'
   -H 'Content-Type: application/json' -X POST
   http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool
   curl --path-as-is -v -d '{"ResourceAddress": "/./<node name>/sync/ptp-status/clock-class",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type: application/json'
   -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool

   # subscribe Os clock

   curl --path-as-is -v -d '{"ResourceAddress": "/././sync/sync-status/os-clock-sync-state",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type:
   application/json' -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool
   curl --path-as-is -v -d '{"ResourceAddress": "/./<node name>/sync/sync-status/os-clock-sync-state",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type: application/json'
   -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool

   # subscribe gnss

   curl --path-as-is -v -d '{"ResourceAddress": "/././sync/gnss-status/gnss-sync-status",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type: application/json'
   -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool
   curl --path-as-is -v -d '{"ResourceAddress": "/./<node name>/sync/gnss-status/gnss-sync-status",
   "EndpointUri": "http://127.0.0.1:9090/v2/resource_status/ptp"}' -H 'Content-Type:
   application/json' -X POST
   http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool

   ## List subscriptions

   curl --path-as-is -v -H 'Content-Type: application/json'
   http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions |
   python -m json.tool

   # unsubscribe

   curl --path-as-is -X DELETE -v -H 'Content-Type: application/json'
   http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v2/subscriptions/b3862aa2-3499-11ed-a5b5-522422c3cf7d

.. image:: figures/cak1614112389132.png
    :width: 800

