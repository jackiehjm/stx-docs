
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

        +-----------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------+
        | Value                 | Description                                                                                                 | Default                                                                                |
        +=======================+=============================================================================================================+========================================================================================+
        | namespace             | The namespace to use for chart resources.                                                                   | default                                                                                |
        |                       |                                                                                                             |                                                                                        |
        |                       |                                                                                                             | Specifying namespace in a helm overrides file without a value will result in an error. |
        +-----------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------+
        | app\_label            | The label for the daemonset to find its pods.                                                               | node-feature-discovery                                                                 |
        +-----------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------+
        | image                 | The docker image to use for the pods.                                                                       | quay.io/kubernetes\_incubator/node-feature-discovery:v0.3.0                            |
        +-----------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------+
        | scan\_interval        | The interval \(in seconds\) to scan the node features.                                                      | 60                                                                                     |
        +-----------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------+
        | node\_selector\_key   | A key/value pair to match against node labels and select which nodes should run the node feature discovery. | All nodes.                                                                             |
        |                       |                                                                                                             |                                                                                        |
        | node\_selector\_value |                                                                                                             |                                                                                        |
        +-----------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------+

    For example, to set the scan interval to 30 seconds:

    .. code-block:: none

        ~(keystone_admin)$ cat <<EOF > /home/sysadmin/my-discovery-overrides.yaml
        scan_interval:30
        EOF

#.  Run the node feature discovery helm chart.

    -   To accept the default value, run :command:`helm` without specifying
        an overrides file:

        .. code-block:: none

            ~(keystone_admin)$ helm upgrade -i node-feature-discovery helm upgrade -i node-feature-discovery stx-platform/node-feature-discovery

    -   If you have defined default overrides in a yaml file, specify the
        file when running :command:`helm`.

        For example:

        .. code-block:: none

            ~(keystone_admin)$ helm upgrade -i node-feature-discovery helm upgrade -i node-feature-discovery stx-platform/node-feature-discovery --values=/home/sysadmin/my-discovery-overrides.yaml

    One pod is created per node, which runs either once per minute or at the
    interval you specified \(30 seconds in this example\) to update the node
    features.
