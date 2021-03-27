
.. jff1614105111370
.. _create-test-and-terminate-a-ptp-notification-demo:

===================================================
Create, Test, and Terminate a PTP Notification Demo
===================================================

This section provides instructions on accessing, creating, testing and
terminating a **ptp-notification-demo**.

.. rubric:: |context| 


Use the following procedure to copy the tarball from |dnload-loc|, create, test,
and terminate a ptp-notification-demo.

.. rubric:: |proc|


.. _create-test-and-terminate-a-ptp-notification-demo-steps-irz-5w4-t4b:

#.  Copy the **ptp-notification-demo\_v1.0.2.tgz** file from |prod-long|
    at `http://mirror.starlingx.cengn.ca/mirror/starlingx/
    <http://mirror.starlingx.cengn.ca/mirror/starlingx/>`__ to yor system, and extract its content.

    .. note::
        The tarball includes the docker file and code to build the reference
        API application, and the Helm chart to install the Sidecar along with
        the application.

    The following files are part of the tarball:


    -   Helm charts


        -   Chart.yaml

        -   values.yaml

        -   \_helpers.tpl

        -   configmap.yaml

        -   deployment.yaml

        -   .helmignore

        -   ptp-notification-override.yaml

        -   app\_start.sh

        -   sidecar\_start.sh


    -   notification-docker


        -   Dockerfile

        -   api



    .. note::
        The demo uses the following images:


        -   starlingx/notificationclient-base:stx.5.0-v1.0.3

        -   ptp-base:1.0.1


#.  Build the **ptp-base:1.0.1** image using the following commands.

    .. code-block:: none

        $ tar xvf ptp-notification-demo_<v1.0.2>.tgz
        $ cd ~/notification-dockers/ptp-base/
        $ sudo docker build . -t ptp-base:1.0.1
        $ sudo docker save ptp-base:1.0.1 -o ptp-base.1.0.1.tar
        $ sudo ctr -n k8s.io image import ./ptp-base.1.0.1.tar
        $ cd ~/charts
        $ tar xvf ptp-notification-demo-1.tgz

    .. note::
        For |AIO|-SX and AIO-DX systems, ptp-base.1.0.1.tar should be copied to
        each node and the import command, :command:`sudo ctr -n k8s.io image
        import ./ptp-base.1.0.1.tar` should be run on each node.

#.  Install the demo's pod using the following commands.

    .. note::
        This pod includes two containers, Sidecar and the referenced API
        application.

    .. code-block:: none

        $ kubectl create namespace ptpdemo 
        $ helm install -n notification-demo ~/charts/ptp-notification-demo -f ~/charts/ptp-notification-demo/ptp-notification-override.yaml 
        $ kubectl get pods -n ptpdemo

    .. code-block:: none

        NAME                                         READY   STATUS   RESTARTS AGE
        notification-demo-ptp-notification-demo-cf7b65c47-s5jk6 2/2     Running   0       5m50s

#.  Test the **ptp-notification** demo.


    #.  Display the app logs using the following command.

        .. code-block:: none

            $ kubectl logs -f notification-demo-ptp-notification-demo-<xyz> -c ptp-notification-demo-app -n ptpdemo


#.  In another terminal, access the application container.

    .. code-block:: none

        $ kubectl exec -it notification-demo-ptp-notification-demo-<zyz> -c ptp-notification-demo-app -n ptpdemo -- bash


    #.  Check if you can pull |PTP| status using the REST API.

        .. code-block:: none

            $ curl -v -H 'Content-Type: application/json' http://127.0.0.1:8080/ocloudNotifications/v1/PTP/CurrentState

    #.  Subscribe to |PTP| notifications.

        .. code-block:: none

            $ curl -v -d '{"ResourceType": "PTP", "ResourceQualifier": {"NodeName": "controller-0"}, "EndpointUri": "http://127.0.0.1:9090/v1/resource_status/ptp"}' -H 'Content-Type: application/json' -X POST http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v1/subscriptions |python -m json.tool

    #.  Retrieve a list of subscriptions.

        .. code-block:: none

            $ curl -v -H 'Content-Type: application/json' http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v1/subscriptions |python -m json.tool

        For example, to get a specific subscription, use the following command.

        .. code-block:: none

            $ curl -v -H 'Content-Type: application/json' http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v1/subscriptions/<subscriptionId>

    #.  To delete a specific subscription with the subscription ID, run the
        following command.

        .. code-block:: none

            $ curl -X DELETE -v -H 'Content-Type: application/json' http://127.0.0.1:${SIDECAR_API_PORT}/ocloudNotifications/v1/subscriptions/<subscriptionId>


#.  Terminate the demo using the following command.

    .. code-block:: none

        $ helm del --purge notification-demo


