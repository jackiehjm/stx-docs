
.. gks1588335341933
.. _the-cert-manager-bootstrap-process:

=====================================
Configure cert-manager at Bootstrap
=====================================

Both nginx-ingress-controller and cert-manager are installed at bootstrap time
with defaults appropriate to most use cases, but their configuration can be
modified at bootstrap.

Nginx-ingress-controller and cert-manager are packaged as armada system
applications.

Both system applications are uploaded and applied, by default, as part of
the bootstrap phase of the |prod-long| installation.
/usr/share/ansible/stx-ansible/playbooks/host\_vars/bootstrap/default.yml
contains the following definition:

.. code-block:: none

    ...
    applications:
      - /usr/local/share/applications/helm/nginx-ingress-controller-1.0-0.tgz:
      - /usr/local/share/applications/helm/cert-manager-1.0-0.tgz:
    ...


As with other parameters in default.yml, you can override this definition in
$HOME/localhost.yml. In the case of the ``applications``: parameter, do this to
change the application helm overrides for an application.

The full general syntax for the ``applications:`` structure is:

.. code-block:: none

    applications:
      - /full/path/to/appOne-1.0-0.tgz:
          overrides:
            - chart: appOne-ChartOne
              namespace: kube-system
              values-path: /home/sysinv/appOne-ChartOne-overrides.yaml
            - chart: appOne-ChartTwo
              namespace: kube-system
              values-path: /home/sysinv/appOne-ChartTwo-overrides.yaml
      - /full/path/to/appTwo-1.0-0.tgz:
          overrides:
            - chart: appTwo-ChartOne
              namespace: kube-system
              values-path: /home/sysinv/appTwo-ChartOne-overrides.yaml

If you do override ``applications:`` in $HOME/localhost.yml, note the following:


.. _the-cert-manager-bootstrap-process-ul-o3j-vdv-nlb:

-   The applications: definition in localhost.yml replaces rather than
    augments the definition in default.yml.

-   Semantically, nginx-ingress-controller and cert-manager are mandatory
    and must be in this order, otherwise bootstrap fails.


|org| recommends that you copy ``applications:`` from default.yml and add in
any required overrides.

At a high-level, the default configuration for the two mandatory applications is:


.. _the-cert-manager-bootstrap-process-ul-dxm-q2v-nlb:

-   nginx-ingress-controller

    -   Runs as a DaemonSet only on masters/controllers.

    -   Uses host networking, which means it can use any port numbers.

    -   Does not change the nginx default ports of 80 and 443.

    -   Has a default backend.


-   cert-manager


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

-   Nginx-ingress-controller

    `https://github.com/kubernetes/ingress-nginx/tree/controller-v0.41.2 <https://github.com/kubernetes/ingress-nginx/tree/controller-v0.41.2>`__

-   cert-manager

    `https://github.com/jetstack/cert-manager/blob/release-0.15/deploy/charts/cert-manager/README.template.md <https://github.com/jetstack/cert-manager/blob/release-0.15/deploy/charts/cert-manager/README.template.md>`__


