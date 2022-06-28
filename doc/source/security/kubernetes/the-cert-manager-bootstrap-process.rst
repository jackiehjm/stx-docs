
.. gks1588335341933
.. _the-cert-manager-bootstrap-process:

===================================
Configure cert-manager at Bootstrap
===================================

Both ``nginx-ingress-controller`` and ``cert-manager`` are packaged as |prod|
system applications. They are uploaded and applied, by default at bootstrap
time with defaults appropriate to most use cases, but their configuration can
be modified at bootstrap.

To override the default configuration add an applications section in
``$HOME/localhost.yml``, as shown below:

.. code-block:: none

    applications:
      - usr/local/share/applications/helm/nginx-ingress-controller-{version}.tgz:
          overrides:
            - chart: appOne-ChartOne
              namespace: kube-system
              values-path: /home/sysinv/appOne-ChartOne-overrides.yaml
            - chart: appOne-ChartTwo
              namespace: kube-system
              values-path: /home/sysinv/appOne-ChartTwo-overrides.yaml
      - /usr/local/share/applications/helm/cert-manager-{version}.tgz:
          overrides:
            - chart: appTwo-ChartOne
              namespace: kube-system
              values-path: /home/sysinv/appTwo-ChartOne-overrides.yaml

.. note::

    Semantically, ``nginx-ingress-controller`` and ``cert-manager`` are
    mandatory and must be in this order, otherwise bootstrap fails.

At a high-level, the default configuration for the two mandatory applications is:


.. _the-cert-manager-bootstrap-process-ul-dxm-q2v-nlb:

-   ``nginx-ingress-controller``


    -   Runs as a DaemonSet only on controllers.

    -   Uses host networking, which means it can use any port numbers.

    -   Does not change the nginx default ports of 80 and 443.

    -   Has a default backend.


-   ``cert-manager``


    -   Runs as a Deployment only on controllers.

    -   Runs with a podAntiAffinity rule to prevent multiple pods of
        deployment from running on the same node.

    -   The deployment replicaCount is set to 1 for bootstrap.

.. note::

    replicaCount can NOT be changed at bootstrap time. The second controller
    must be configured and unlocked before replicaCount can be set to 2.

The Helm Chart Values that you can override are described on the following
web pages:


.. _the-cert-manager-bootstrap-process-ul-d4j-khv-nlb:

-   ``nginx-ingress-controller``

    `https://github.com/kubernetes/ingress-nginx/blob/controller-v1.1.1/charts/ingress-nginx/values.yaml <https://github.com/kubernetes/ingress-nginx/blob/controller-v1.1.1/charts/ingress-nginx/values.yaml>`__

-   ``cert-manager``

    `https://github.com/cert-manager/cert-manager/blob/release-1.7/deploy/charts/cert-manager/values.yaml <https://github.com/cert-manager/cert-manager/blob/release-1.7/deploy/charts/cert-manager/values.yaml>`__
