
..
.. _kubernetes-user-tutorials-metrics-server:

==============
Metrics Server
==============

|release-caveat|

Metrics Server is a scalable, efficient source of container resource metrics for Kubernetes
built-in autoscaling pipelines.

It collects resource metrics from Kubelets, exposing them as part of Kubernetes
apiserver through the Metrics API, which can be used via Kubernetes' Horizontal
Pod Autoscaler definitions. Also, it can be used directly by end user's containerized
applications to, for example, enable application-specific load management mechanisms.

Metrics being collected by Metrics Server can be accessed by :command:`kubectl
top`. This is available for debugging autoscaling pipelines.

For more information see: `https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/
<https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/>`__.

---------------------
Metrics API use cases
---------------------

**************************************************
Use kubectl autoscaler to scale pods automatically
**************************************************

.. rubric:: |context|

It is possible to use Kubernetes autoscaler to scale up and down a Kubernetes
deployment based on the load. Please refer to the official example
`https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
<https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/>`__
to create a PHP application which scales horizontally.

.. rubric:: |proc|

After application deployment has completed, you can create a horizontal pod
autoscaling (hpa) definition for the deployment as follows:

#.  Use the following command to turn on autoscaling:
    .. code-block::

        ~(keystone_admin)$ kubectl autoscale deployment <your-application> --cpu-percent=50 --min=1 --max=10

#.  Use the following command to see the created horizontal pod autoscaler:

    .. code-block::

        ~(keystone_admin)$ kubectl get hpa

#.  When the incoming load to your application deployment increases and the
    percentage of CPU for existing replicas exceed the previously specified
    threshold, a new replica will be created. For the PHP example above, use the
    following command to increase the incoming load:

    .. code-block::

        ~(keystone_admin)$ kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

#.  (Optional) Use the following commands to check if replicas were created:
    .. code-block::

        ~(keystone_admin)$ kubectl get hpa

    or

    .. code-block::

        ~(keystone_admin)$ kubectl get deployment <your-application>

    If you delete the pod load-generator it will decrease the number of replicas automatically.

************************************************
Using Metrics API directly within your container
************************************************

It is also possible to use the metrics API directly within your containerized
application in order to trigger application-specific load management.

The Metrics API consists of the following ``GET`` endpoints under the base path
``/apis/metrics.k8s.io/v1beta1``:

``/nodes``
    All node metrics

``/nodes/{node}``
    Metrics for a specified node

``/namespaces/{namespace}/pods``
    All pod metrics within namespace that support all-namespaces

``/namespaces/{namespace}/pods/{pod}``
    Metrics for a specified pod

``/pods``
    All pod metrics of all namespaces

Sample application
******************

This NodeJS-based application requests metrics every second printing them in the console.

For a sample containerized application that uses the Metrics API, see:
`https://opendev.org/starlingx/metrics-server-armada-app/src/branch/master/sample-app
<https://opendev.org/starlingx/metrics-server-armada-app/src/branch/master/sample-app/>`__.

All the requirements to deploy and run the sample application are captured in the sample-app.yml
file: service account, roles and role binding that allow the application to
communicate with the apiserver, pod.

The application pulls the token associated with the service account from its
default location (\/var/run/secrets/kubernetes.io/serviceaccount/token\) in
order to perform authenticated requests to the /apis/metrics.k8s.io/v1beta1/pods endpoint.

Sample application structure
****************************

.. code-block:: none

    - sample-app.yml
    - Dockerfile
    - src
        - package.json
        - sample-application.js

sample-app.yml
  Contains sample-app Kubernetes Deployment, Cluster Role, Cluster Role Binding
  and Service Account

src
  Contains NodeJS application

Dockerfile
  Application Dockerfile

Run sample application
**********************

.. rubric:: |proc|

#.  Run the following command to deploy the application using the sample-app.yml file:

    .. code-block::

        ~(keystone_admin)$ kubectl apply -f sample-app.yml

#.  Run the following command to check if the application pod is running:

    .. code-block::

        ~(keystone_admin)$ kubectl get pods -n sample-application-ns

#.  Run the following command to view the logs and check if the sample
    application is requesting successfully the Metrics Server API:

    .. code-block::

        ~(keystone_admin)$ kubectl logs -n sample-application-ns pod-name --tail 1 -f

.. seealso::

    -   Official example of horizontal pod autoscale:
        `https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
        <https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/>`__

    -   Metrics API documentation: `https://github.com/kubernetes/metrics
        <https://github.com/kubernetes/metrics>`__

    -   Metrics server documentation:
        `https://github.com/kubernetes-sigs/metrics-server
        <https://github.com/kubernetes-sigs/metrics-server>`__
