
.. dea1561393939185
.. _running-the-node-feature-discovery-helm-chart:

=========================================
Run the Node Feature Discovery Helm Chart
=========================================

Node feature discovery detects hardware features available on each node in a
Kubernetes cluster, and advertises those features using Kubernetes node
labels.

An **stx-platform** helm repository containing platform related charts,
including the **node-feature-discovery** helm chart, is created
automatically once the system has been installed.

.. rubric:: |proc|

#.  Confirm that the **stx-platform** is available.

    .. code-block:: none

        ~(keystone_admin)$ helm repo list
        NAME            URL
        stable          https://kubernetes-charts.storage.googleapis.com
        local           http://127.0.0.1:8879/charts
        starlingx       http://127.0.0.1:8080/helm_charts/starlingx
        stx-platform    http://127.0.0.1:8080/helm_charts/stx-platform

    The repository is created automatically after system installation has
    completed. There may be a delay of a few minutes after a new install
    before it is available.

#.  Create a helm override file to specify custom values for any of the
    following:

    .. table::
        :widths: auto

        +--------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
        | Override Name      | Description                                                                                                        | Default                                                                                                              |
        +====================+====================================================================================================================+======================================================================================================================+
        | image:             | The docker image to use for the pods.                                                                              | k8s.gcr.io/nfd/node-feature-discovery                                                                                |
        | repository:        |                                                                                                                    |                                                                                                                      |
        +--------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
        | worker:            | The Kubernetes nodeSelector to use for the worker pods.                                                            | All nodes.                                                                                                           |
        | nodeSelector:      | This is a key/value pair to match against node labels and select which nodes should run the node feature discovery.| Changing the {} to {foo: bar} will result in the worker pods only running on Kubernetes nodes labelled with foo:bar. |
        | {}                 |                                                                                                                    |                                                                                                                      |
        +--------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
        | fullnameOverride:  | The base name to use for the Kubernetes resources (pods, daemonsets, etc.).                                        | A blank entry here will result in the base name being "node-feature-discovery".                                      |
        +--------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+

    For example, to set the base name to "nfd" and to run the worker pod only
    on nodes with the "foo: bar" label:

    .. code-block:: none

        ~(keystone_admin)$ cat <<EOF > /home/sysadmin/my-discovery-overrides.yaml
        fullnameOverride: nfd
        worker:
        nodeSelector:
        foo: bar
        EOF

#.  Run the node feature discover helm chart. It is recommended to run it in
    the "kube-system" namespace so the pods run on the platform CPUs.

    -   To accept the default values, run :command:`helm` without specifying an
        overrides file:

        .. code-block:: none

            ~(keystone_admin)$ helm -n kube-system upgrade -i node-feature-discovery stx-platform/node-feature-discovery

    -   If you have defined default overrides in a yaml file, specify the
        file when running :command:`helm`.

        For example:

        .. code-block:: none

            ~(keystone_admin)$ helm -n kube-system upgrade -i node-feature-discovery stx-platform/node-feature-discovery --values=/home/sysadmin/my-discovery-overrides.yaml

    One worker pod is created per node, which runs once per minute to update
    the node features.  One master pod gathers up all the data and reports it
    to Kubernetes.
