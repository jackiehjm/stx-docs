
.. jxy1562587174205
.. _accessing-the-kubernetes-dashboard:

===============================
Access the Kubernetes Dashboard
===============================

You can optionally use the Kubernetes Dashboard web interface to manage your
hosted containerized applications.

.. rubric:: |proc|

.. _accessing-the-kubernetes-dashboard-steps-azn-yyd-tkb:

#.  Access the dashboard at ``https://<oam-floating-ip-address OR fqdn>:
    <kube-dashboard-port>``

    where <kube-dashboard-port> is the port that the dashboard was installed
    on. Contact your |prod| administrator for this information.

    Depending on the certificate used by your |prod| administrator for
    installing the Kubernetes Dashboard, you may need to install a new Trusted
    Root CA or acknowledge an insecure connection in your browser.

#.  Select the **kubeconfig** option for signing in to the Kubernetes
    Dashboard.

    .. note::
        Your kubeconfig file containing credentials specified by your
        StarlingX administrator (see :ref:`Installing kubectl and Helm Clients
        Directly on a Host
        <kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host>`)
        is typically located at $HOME/.kube/config .

    You are presented with the Kubernetes Dashboard for the current context
    \(cluster, user and credentials\) specified in the **kubeconfig** file.
