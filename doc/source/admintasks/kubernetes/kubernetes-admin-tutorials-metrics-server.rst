
..
.. _kubernetes-admin-tutorials-metrics-server:

======================
Install Metrics Server
======================

|release-caveat|

.. rubric:: |context|

Metrics Server is a scalable, efficient source of container resource metrics for Kubernetes
built-in autoscaling pipelines.

Metrics Server is meant for autoscaling purposes only. It is not intended to
provide metrics for monitoring solutions that persist and analyze historical metrics.

Specifically, in |prod|, Metrics Server supports:

*   Use of Kubernetes' horizontal application auto-scaling based on resources
    consumption, for scaling end users' containerized application deployments.
*   Use of Metrics Server API within end user's containerized applications in
    order for end user's application to, for example, enable application-specific
    incoming load management mechanisms based on metrics of selected pods.

For details on leveraging Metrics Server for horizontal autoscaling or for
Metrics API, see :ref:`Kubernetes User Tasks <kubernetes-user-tutorials-metrics-server>`.
Metrics Server is an optional component of |prod|.  It is packaged as a system
application and included in the |prod| installation ISO.  In order to enable
Metrics Server, you must upload and apply the Metrics Server system
application.

.. rubric:: |proc|

Perform the following steps to enable Metrics Server such that its services are
available to containerized applications for horizontal autoscaling and/or use
of Metrics API.

#.  Go to the path ``/usr/local/share/applications/helm/`` to access ``metrics-server-nn.nn-0.tgz``

#.  Upload the application tarball:

    .. code-block::

        ~(keystone_admin)]$ system application-upload metrics-server-nn.nn-0.tgz

#.  Run the application list to confirm that it was uploaded:

    .. code-block::

        ~(keystone_admin)]$ system application-list

#.  Run the application to apply the metrics server:

    .. code-block::

        ~(keystone_admin)]$ system application-apply metrics-server

#.  Run the application list to confirm it was applied:

    .. code-block::

        ~(keystone_admin)]$ system application-list

#.  Run the following command to see the pod running:

    .. code-block::

        ~(keystone_admin)]$ kubectl get pods -l app=metrics-server -n metrics-server

.. important::

    After a platform upgrade, the Metrics Server will NOT be automatically
    updated.

    To update the Metrics Server, run the following command after the upgrade
    was completed with no alarms:

    .. code-block:: none

        ~(keystone_admin)]$ system application-update /usr/local/share/applications/helm/metrics-server-1.0-18.tgz


For details on leveraging Metrics Server for horizontal autoscaling or for
Metrics API, see :ref:`Kubernetes User Tasks <kubernetes-user-tutorials-metrics-server>`.
After installing Metrics Server, the :command:`kubectl top` |CLI| command is available
to display the metrics being collected by Metrics Server and the ones being
used for defined autoscaling definitions. These metrics are also displayed
within the Kubernetes Dashboard.

For more information see:
`https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#top
<https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#top>`__


